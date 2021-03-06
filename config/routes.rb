require "base.rb"
Consume::Application.routes.draw do
  root :to => "home#index"

  devise_for :users#, controllers: { sessions: :sessions }

  resources :users do
    collection do
      get "search"
    end
    member do
      get    "group", as: :ask_group
      post   "group", as: :agree_group
      delete "group", as: :refuse_group
    end
  end
  resources :records
  resources :tags
  resources :tags
  resources :comments

  namespace :cpanel do
    root :to => "home#index"
    get "reports" => "home#reports"
    get "report"  => "home#report"
    resources :users
    resources :records
    resources :tags
    resources :comments
  end

  get "/apis"    => "home#apis"
  get "/solife"  => "home#solife_get"
  post "/solife" => "home#solife_post"

  mount Consume::API::Base => "/api"

  match "*path", via: :all, to: "home#not_found"
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
