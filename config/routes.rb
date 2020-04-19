# frozen_string_literal: true

Rails.application.routes.draw do

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
      post 'track_social'
      post 'track_time'
      post 'submit_feedback'
    end
  end

  scope module: :admin do
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
  end

  namespace :admin do
    resources :categories
  end

  resources :categories, only: :index

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  # /users/:path
  resources :users, only: %i[index show]

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

  # /projects/:path
  resources :projects do
    get 'explore', on: :collection

    # TODO: change the name?
    member do
      get 'count'
      patch 'change_status'
    end

    scope module: :projects do
      resources :teams, except: %i[index] do
        collection do
          get 'manage'
          get 'manage_data'
          post 'manage', to: 'teams#save_manage'
        end

        delete 'remove_user', on: :member
      end

      resources :tasks

      shallow do
        scope module: :appeals do
          resources :invitations, only: %i[index create destroy] do
            post 'accept', on: :member
          end

          resources :applications, only: %i[index create destroy] do
            post 'accept', on: :member
          end
        end
      end
    end
  end

  # /notifications/:path
  resources :notifications, only: %i[index destroy] do
    member do
      patch 'read'
      patch 'unread'
    end

    patch 'read_all', on: :collection
  end

  authenticated :user do
    root to: 'projects#index', as: :authenticated_root
  end

  root to: 'pages#home'
end
