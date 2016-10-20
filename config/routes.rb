Rails.application.routes.draw do
  get 'browser', :to => 'static_pages#browser', :as => "browser"
  get 'price', :to => 'static_pages#price', :as => "price"
  get 'description', :to => 'static_pages#description', :as => "description"
  get 'description_excel', :to => 'static_pages#description_excel', :as => "description_excel"
  get 'switch(/:id)' => 'sessions#switch'
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
  get 'my_invoice(/:id)', :to => "traders#my_invoice", :as => "my_invoice"
  get 'random_schedule', :to => "projects#generate_random_schedule"
  post 'projects/store_pdf', :to => "projects#store_pdf"

  get 'admin/get_committed_waiting_projects', :to => "admin#get_committed_waiting_projects"
  get 'admin/get_uncommitted_projects', :to => "admin#get_uncommitted_projects"
  get 'admin/get_uncommitted_projects_immediately', :to => "admin#get_uncommitted_projects_immediately"
  get 'admin/set_project_committed/(:id)', :to => "admin#set_project_committed"
  get 'admin/upload_pdf', :to => "admin#upload_pdf"
  get 'admin/get_delete_requesting_projects', :to => "admin#get_delete_requesting_projects"
  get 'admin/get_delete_requesting_committed_projects', :to => "admin#get_delete_requesting_committed_projects"
  get 'admin/set_delete_requesting_projects_deleted', :to => "admin#set_delete_requesting_projects_deleted"
  get 'admin/get_project_by_id/(:id)', :to => "admin#get_project_by_id"
  get 'admin/renew_company_codes', :to => "admin#renew_company_codes"
  get 'admin/analysis', :to => "admin#analysis", :as => "analysis"
  post 'admin/update_company_codes', :to => "admin#update_company_codes"
  get 'admin/delete_payoff', :to => "admin#delete_payoff"
  get 'admin/create_payoff', :to => "admin#create_payoff"
  get 'admin/delete_confirmation', :to => "admin#delete_confirmation"
  get 'admin/create_confirmation', :to => "admin#create_confirmation"
  get 'admin/check_invoice', :to => "admin#check_invoice"

  get 'admin', :to => "admin#index", :as => "admin"
  get 'admin/paid_all', :to => "admin#paid_all"
  get 'admin/unpaid_all', :to => "admin#unpaid_all"
  get 'admin/invoice', :to => "admin#invoice"
  get 'admin/invoice_internal', :to => "admin#invoice_internal", :as => "invoice_internal"
  get 'admin/useragent', :to => "admin#useragent"
  get 'projects/signature/(:id)', :to => "projects#signature"
  get 'projects/(:id)/temporary_report', :to => "projects#temporary_report"

  get 'code', :to => "company_codes#code"

  get 'api/translate', :to => "api#translate", :as => "translate"
  get 'api/translate_result', :to => "api#translate_result"

  # api
  namespace :api, {format: 'json'} do
    namespace :visa do
      #get '/', :action => 'index'
      post '/session', :action => 'login'
      post '/new', :action => 'new'
      get '/pdf', :action => 'check'
      get '/delete', :action => 'delete'
      get '/codes', :action => 'code'
    end
  end

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
