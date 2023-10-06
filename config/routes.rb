require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda {|u| u.admin?} do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks'}
  
  get 'search', to: 'search#search'

  concern :voted do
    member do
      patch :like
      patch :dislike
      delete :cancel
    end
  end

  concern :commented do
    member do
      post :comment
    end
  end

  namespace :user do
    post '/send_email', to: 'send_email#create'
  end
  
  resources :questions, concerns: %i[voted commented] do
    resources :answers, concerns: %i[voted commented], shallow: true do
      patch :select_best, on: :member
    end

    resources :subscriptions, only: [:create, :destroy], shallow: true
  end

  namespace :api do
    namespace :v1 do
      resource :profiles, only: [] do
        get :me, on: :collection
        get :index, on: :collection
      end

      resources :questions, except: [:new, :edit] do
        resources :answers, except: [:new, :edit], shallow: true
      end
    end
  end

  root to: "questions#index"

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :badges, only: :index
  # resources :authorizations, only: [] do
  #   get :email_request, on: :member
  #   get :create_user, on: :member
  # end

  mount ActionCable.server => '/cable'
end
