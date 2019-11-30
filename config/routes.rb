Rails.application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'
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

  # /:page
  resources :pages, path: '', only: [] do

    collection do
      get 'pricing'
      get 'about'
      get 'newsletter'
      get 'love'
      get 'feedback'
      get 'features'
    end

  end

  # Class to set constraint to only allow AJAX request
  class OnlyAjaxRequest
    def matches?(request)
      request.xhr?
    end
  end

  #/track_time, for analytics
  post "/track_time", to: "pages#track_time", constraint: OnlyAjaxRequest.new
  #/update_graph_time, receives JSON of date and gets values for graphs
  post "/update_graph_time", to: "metrics#update_graph_time", constraint: OnlyAjaxRequest.new

  # /metrics/:page
  resources :metrics, only: :index do

    collection do
      get 'newsletter'
      get 'traffic'
    end

  end

  root to: "pages#home"
end
