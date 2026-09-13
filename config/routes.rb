Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  # ตั้งค่าให้เข้า 127.0.0.1:3000 แล้วเด้งไปหน้า Log in ทันที
  # devise_scope :user do
  # root to: "devise/sessions#new"
  # ตั้งค่าให้เข้า 127.0.0.1:3000 แล้วเด้งไปหน้า index ของ Products ทันที
  # end
  root to: "pages#home"
  get "contact", to: "pages#contact", as: :contact

  resources :products, only: [ :index, :show ]
  resources :categories, only: [ :show ]
  resource :cart, only: [ :show ]
  resources :cart_items, only: [ :create, :update, :destroy ] do
    member do
      post :increase
      post :decrease
    end
  end
  resources :orders, only: [ :index, :show, :new, :create ]
  resources :orders do
    member do
      patch :upload_slip
    end
  end
end
