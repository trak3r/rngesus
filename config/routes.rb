# frozen_string_literal: true

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
  resources :rolls do
    # Wizard step 1: choose creation method
    get 'new/choose_method', on: :collection, action: :choose_method, as: :choose_method
    # Wizard upload flow: create dummy roll and redirect to upload
    post 'create_with_img_upload', on: :collection, action: :create_with_img_upload

    post :toggle_like, on: :member

    member do
      post :reroll
      get 'edit_name'
    end

    resources :results, shallow: true, except: [:show]
    resources :results_csvs
    resources :results_imgs
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
  root 'rolls#index'
end
