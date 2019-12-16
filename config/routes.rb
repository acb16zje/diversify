# frozen_string_literal: true

Rails.application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'
  devise_for :users
  match '/403', to: 'errors#error_403', via: :all
  match '/404', to: 'errors#error_404', via: :all
  match '/422', to: 'errors#error_422', via: :all
  match '/500', to: 'errors#error_500', via: :all

  # /:path
  resources :pages, path: '', only: [] do

    collection do
      get 'pricing'
      get 'about'
      get 'newsletter'
      get 'love'
      get 'feedback'
      get 'features'

      # For analytics
      post 'track_time'
      post 'submit_feedback'
    end
  end

  # /metrics/:path
  resources :metrics, only: :index do

    collection do
      get 'newsletter'
      get 'traffic'

      # Receives JSON of date and gets values for graphs
      post 'update_graph_time'
    end
  end

  # /newsletters/:path
  resources :newsletters, only: %i[index create new show] do

    collection do
      post 'subscribe'

      get 'unsubscribe'
      get 'subscribers'
      post 'unsubscribe', to: 'newsletters#create_unsubscribe'
    end
  end

  root to: 'pages#home'
end
