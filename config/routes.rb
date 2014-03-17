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

  devise_for :users, :controllers => {:registrations => "registrations", :sessions => "sessions"}

  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'
  end
  resources :clients do
  collection { post :search, to: 'clients#index' }
  collection { get :search, to: 'clients#index' }
    member do
      get :appointments
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
      get :workouts
      get :editordata
    end
  end
  resources :agendas, only: [:create, :destroy, :update]
  resources :exercises do
    collection { post :search, to: 'exercises#index' }
    collection { get :search, to: 'exercises#index' }
  end
  resources :workouts do
    collection do
      get :trans
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
