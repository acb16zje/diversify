# frozen_string_literal: true

Rails.application.routes.draw do

  match '/403', to: 'errors#error_403', via: :all
  match '/404', to: 'errors#error_404', via: :all
  match '/422', to: 'errors#error_422', via: :all
  match '/500', to: 'errors#error_500', via: :all

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  # notify_to :users, controller: 'users/notifications'

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
      post 'track_social'
      post 'track_time'
      post 'submit_feedback'
    end
  end

  # /metrics/:path
  resources :metrics, only: :index do
    collection do
      get 'newsletter'
      get 'traffic'
      get 'social'
    end
  end

  # /charts/:path
  resources :charts, only: [] do
    collection do
      get 'subscription_ratio'
      get 'subscription_by_date'
      get 'landing_page_feedback'

      get 'social_share_ratio'
      get 'social_share_by_date'

      get 'referrers_ratio'
      get 'referrers_by_date'
      get 'average_time_spent_per_page'
      get 'number_of_visits_per_page'

      get 'newsletter_subscription_by_date'
      get 'unsubscription_by_newsletter'
      get 'unsubscription_reason'
    end
  end

  # /newsletters/:path
  resources :newsletters, only: %i[index create new show] do
    collection do
      get 'subscribers'
      get 'unsubscribe'

      post 'subscribe'
      post 'unsubscribe', to: 'newsletters#post_unsubscribe'
    end
  end

  # /users/:path
  resources :users, only: %i[index show] do
    collection do
      delete 'disconnect_omniauth'
    end
  end

  # /settings/:path
  scope module: :users do
    namespace :settings do
      resource :profile, only: %i[show update] do
        delete 'remove_avatar'
      end

      resource :account, only: :show do
        delete 'disconnect_omniauth'
        put 'reset_password'
      end

      resource :billing, only: %i[show update]

      resource :personality, only: %i[show update]

      resource :emails, only: :show do
        post 'subscribe'
        post 'unsubscribe'
      end
    end
  end

  # /categories/:path
  resources :categories, only: :index

  # /projects/:path
  resources :projects do
    collection do
      get 'explore'
    end

    member do
      patch 'change_status'
      get 'count'
      get 'data'
    end

    resources :teams, except: %i[index] do
      collection do
        get 'manage'
        post 'manage', to: 'teams#save_manage'
        get 'manage_data'
      end
      member do
        delete 'remove_user'
      end
    end
  end

  resources :invites do
    collection do
      post 'accept'
    end
  end

  resources :notifications, only: :index do
    member do
      get 'open'
    end
    collection do
      post 'open_all'
    end
  end

  authenticated :user do
    root to: 'projects#index', as: :authenticated_root
  end

  root to: 'pages#home'
end
