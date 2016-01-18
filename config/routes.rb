Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

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
  end

end

