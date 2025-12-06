# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength
Rails.application.routes.draw do
  mount_avo
  # for omniauth
  get 'auth/:provider/callback', to: 'sessions#create'
  get '/login', to: 'sessions#new'
  delete '/logout', to: 'sessions#destroy', as: :logout

  # Legal pages
  get 'terms', to: 'pages#terms'
  get 'privacy', to: 'pages#privacy'
  get 'dmca', to: 'pages#dmca'

  resource :user, only: %i[edit update]

  resources :examples
  resources :randomizers do
    post :toggle_like, on: :member

    resources :outcomes, only: [:index] do
      member do
        post :reroll
      end
    end
    resources :rolls, shallow: true do
      member do
        get 'edit_name'
      end
      resources :results, shallow: true, except: [:show]
      resources :results_csvs
      resources :results_imgs
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  root 'randomizers#index'
end
# rubocop:enable Metrics/BlockLength
