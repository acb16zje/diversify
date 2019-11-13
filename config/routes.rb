Rails.application.routes.draw do

  resources :tasks
  resources :reviews
  resources :teams
  resources :projects
  devise_for :users
  match "/403", to: "errors#error_403", via: :all
  match "/404", to: "errors#error_404", via: :all
  match "/422", to: "errors#error_422", via: :all
  match "/500", to: "errors#error_500", via: :all

  get :ie_warning, to: 'errors#ie_warning'
  get :javascript_warning, to: 'errors#javascript_warning'

  resources :pages, path: '', only: [] do

    collection do
      get 'pricing'
      get 'register'
      get 'about'
      get 'feedback'
      get 'contact'
    end

  end

  root to: "pages#home"
end
