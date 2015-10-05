Rails.application.routes.draw do
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  get 'signup', :to => 'traders#new'
  root :to => 'static_pages#home'

  get 'update_status', :to => "projects#update_status"
  get 'update_confirmation', :to => "projects#update_confirmation"
  get 'update_payment', :to => "projects#update_payment"
  get 'delete_request(/:id)', :to => "projects#delete_request", :as => "delete_request"
  get 'cancel_delete_request(/:id)', :to => "projects#cancel_delete_request", :as => "cancel_delete_request"
  get 'projects/index', :to => "projects#index"

  get 'admin/api_projects_need_update', :to => "admin#projects_need_update"
  get 'admin/project_json/(:id)', :to => "admin#project_json"
  get 'admin', :to => "admin#index", :as => "admin"
  get 'admin/paid_all', :to => "admin#paid_all"
  get 'admin/unpaid_all', :to => "admin#unpaid_all"
  get 'admin/invoice', :to => "admin#invoice"
  get 'admin/useragent', :to => "admin#useragent"


  resources :traders
  resources :projects
  resources :company_codes, :only => [:index, :edit, :update]
  resources :sessions, :only => [:new, :create, :destroy]

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
