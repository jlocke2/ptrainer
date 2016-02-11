Ptrainer::Application.routes.draw do
  authenticated :user do
    root :to => 'appointments#index', :as => :authenticated_root
  end
  root :to => redirect('/users/sign_in')

  match '/help',    to: 'static_pages#help',    via: 'get'
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'


  devise_for :users, :controllers => {:registrations => "registrations", :sessions => "sessions", :confirmations => "confirmations"}
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
    match '/user/confirmation' => 'confirmations#update', :via => :patch, :as => :update_user_confirmation
  end
  
  match "appointments/:id/:clientid/removefromapt", to: "appointments#removefromapt", via: :post, as: "removefromapt_appointments"
  match "appointments/toured", to: "appointments#toured", via: :post
  resources :appointments do
    member do
      post :move
      post :resize
      post :join
      get :workouts
      get :editordata
      post :clientremove
    end
    collection do
      get :newdata
      get :mastercalendar
    end
  end
  
  resources :exercises do
    collection do
      post :search, to: 'exercises#index'
      get :search, to: 'exercises#index'
      get :type, to: 'exercises#type'
    end
  end

  resources :workouts
  
end
