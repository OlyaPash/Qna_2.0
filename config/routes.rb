Rails.application.routes.draw do
  devise_for :users

  concern :voted do
    member do
      patch :like
      patch :dislike
      delete :cancel
    end
  end
  
  resources :questions, concerns: :voted do
    resources :answers, concerns: :voted, shallow: true do
      patch :select_best, on: :member
    end
  end

  root to: "questions#index"

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :badges, only: :index
end
