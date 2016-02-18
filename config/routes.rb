Ptrainer::Application.routes.draw do
  authenticated :user do
    root :to => 'appointments#index', :as => :authenticated_root
  end
  root :to => redirect('/users/sign_in')

  match '/help', to: 'static_pages#help', via: 'get'


  devise_for :users, :controllers => {:registrations => "registrations", :sessions => "sessions"}
  devise_scope :users do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end

  resources :users, only: [:create, :edit, :update, :destroy]

  resources :clients, only: [:index, :show]
  
  resources :appointments, only: [:index] do
    member do
      post :move
      post :resize
      get :editordata
    end
    collection do
      get :newdata
    end
  end
  
  resources :exercises, only: [:index, :create, :update, :destroy] do
    collection do
      post :search, to: 'exercises#index'
      get :search, to: 'exercises#index'
      get :type, to: 'exercises#type'
    end
  end

  resources :workouts
  
end
