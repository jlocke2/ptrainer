Ptrainer::Application.routes.draw do
  authenticated :user do
  root :to => 'appointments#index', :as => :authenticated_root
end
root :to => redirect('/users/sign_in')
  match '/help',    to: 'static_pages#help',    via: 'get'
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'

match 'card', to: 'cards#edit', via: :post
match 'payments', to: 'payments#index', via: :get
match 'payments/verify', to: 'payments#verify', via: :post
match 'payments/verify', to: 'payments#verify', via: :get
match 'payments/charge', to: 'payments#charge', via: :post
match 'payments/verify_client_card', to: 'payments#verify_client_card', via: :post
match 'payments/verify_trainer_bank', to: 'payments#verify_trainer_bank', via: :post
match 'payments/delete_client_card', to: 'payments#delete_client_card', via: :post
match 'payments/delete_trainer_bank', to: 'payments#delete_trainer_bank', via: :post
#match 'requests', to: 'clients#requests', via: :get
match "appointments/:id/:clientid/removefromapt", to: "appointments#removefromapt", via: :post, as: "removefromapt_appointments"



  devise_for :users, :controllers => {:registrations => "registrations", :sessions => "sessions", :confirmations => "confirmations"}

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
    match '/user/confirmation' => 'confirmations#update', :via => :patch, :as => :update_user_confirmation
  end
  resources :rotations do
    member do
        get :editdata
        get :enterresults
        patch :submitresults
      end
      collection do
        get :newrotate
      end
  end
  resources :notes , :only => [:create]
  resources :clients do
  collection { post :search, to: 'clients#index' }
  collection { get :search, to: 'clients#index' }
  collection { post :import, to: 'clients#import'}
    member do
      get :appointments
      get :notes
      get :workouts
      get :progress
      patch :progress
      patch :progcharter
      get :progcharter
    end
    post :sort, on: :collection
  end
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
  resources :unavailables do
    member do
      get :editordata
    end
  end
  resources :agendas, only: [:create, :destroy, :update] do
    member do
      get :editdata
    end
  end
  resources :trainers, only: [:setschedule] do
    member do
      patch :setschedule
    end
  end
  resources :requests do
    collection do
      get :newform
      get :requestlist
    end
    member do
      post :confirm
      get :formsforpop
    end
  end
  resources :exercises do
    collection { post :search, to: 'exercises#index' }
    collection { get :search, to: 'exercises#index' }
    collection { get :type, to: 'exercises#type'}
  end
  resources :workouts do
    collection do
      get :trans
      get :workout_email
    end
    member do
      get :results
      patch :results
      post :email
    end
  end
  resource :calendar, :only => [:show]
  resources :stats
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
