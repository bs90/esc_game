Rails.application.routes.draw do
  namespace :admin do
      resources :notifications
      resources :touches
      resources :users
      resources :rooms
      resources :items do
        collection do
          post :sell
        end
      end

      root to: "notifications#index"
    end
  get "home/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root 'home#index'

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: redirect('/')
  get '/login', to: redirect('/auth/google_oauth2')
  get '/logout', to: 'sessions#destroy'

  get '/touch/:id', to: 'home#touch'
  get '/notifications', to: 'home#notifications'
  get '/scanner', to: 'home#scanner'

  get '/items', to: 'home#list_items', as: :list_items
  get '/rooms', to: 'home#list_rooms', as: :list_rooms
  get '/rooms/:id', to: 'home#show_room', as: :room

  # Image proxy for Google Drive images
  get '/images/proxy/:id', to: 'images#proxy', as: :image_proxy
end
