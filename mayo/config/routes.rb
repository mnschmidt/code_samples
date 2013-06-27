Mayo31::Application.routes.draw do
  resources :past_dues do as_routes end
    
  resources :missing_transfers do as_routes end
  
  resources :successful_transfers do as_routes end

  resources :nijmegen_schedulings do as_routes end

  resources :appointments do as_routes end
  
  resources :att_schedulings do as_routes end
  
  resources :leiden_schedulings do as_routes end
    
  resources :enrollments do as_routes end

  resources :events do as_routes end
    
  resources :freesurfer_qualities do as_routes end
    
  resources :initial_scan_qualities do as_routes end
  
  resources :phone_calls do as_routes end

  resources :preprocess_jobs do as_routes end
    
  resources :procedures do as_routes end
    
  resources :sequence_types do as_routes end
  
  resources :sequences do as_routes end

  resources :study_groups do as_routes end
    
  resources :study_procedures do as_routes end

  resources :unrateds do as_routes end

  resources :users do as_routes end

  resources :studies do as_routes end

  resources :upcoming_events do as_routes end
    
  resources :potential_subjects do as_routes end
    
  #resources :unrated do as_routes end
    
  resources :t1s do as_routes end
    
  #resources :reports do 
  #  resources :complete_scans, :missing_scans
  #end

  #resources :admin do as_routes end
    
  resources :subjects do as_routes end
    
  resources :reports
  
  match 'login' => 'admin#login'
  
  match 'logout' => 'admin#logout'
  
  resources :reports
  
  match 'complete_scans' => 'reports#complete_scans'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
   root :to => 'upcoming_events#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
   #match ':controller(/:action(/:id(.:format)))'
end
