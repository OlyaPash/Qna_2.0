Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks'}

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
