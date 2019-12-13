# frozen_string_literal: true
# Class to set constraint to only allow AJAX request
class OnlyAjaxRequest
  def matches?(request)
    request.xhr?
  end
end

Rails.application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'
  resources :tasks
  resources :reviews
  resources :teams
  resources :projects
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
      post 'track_time', constraint: OnlyAjaxRequest.new
      post 'newsletter_subscriptions', as: :newsletter_subscriptions
      post 'feedback_submission', as: :feedback_submission
    end
  end

  # /metrics/:path
  resources :metrics, only: :index do

    collection do
      get 'newsletter'
      get 'traffic'

      # Receives JSON of date and gets values for graphs
      post 'update_graph_time', constraint: OnlyAjaxRequest.new
    end
  end

  # /newsletters/:path
  resources :newsletters, only: %i[index create new show] do

    collection do
      get 'unsubscribe'
      post 'unsubscribe', to: 'newsletters#create_unsubscribe'
    end
  end

  root to: 'pages#home'
end
