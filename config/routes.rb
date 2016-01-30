require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  devise_scope :user do
    post '/finish_registration' => 'omniauth_callbacks#finish_registration'
  end

  root to: "questions#index"

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
      patch :vote_reset
    end
  end

  resources :questions, concerns: :votable do
    resources :comments, defaults: { commentable: 'questions' }
    resources :answers, concerns: :votable do
      resources :comments, defaults: { commentable: 'answers' }
      patch 'set_best', on: :member
    end
    post :subscribe, on: :member
    post :unsubscribe, on: :member
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end
      resources :questions do
        resources :answers
      end
    end
  end
end

