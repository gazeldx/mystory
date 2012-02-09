Cms::Application.routes.draw do
  resources :customizes

  resources :users, :posts, :notes, :blogs, :follows, :memoirs, :albums, :idols, :hobbies

  resources :categories do
    member do
      get 'up'
      get 'down'
    end
  end

  resources :albums do
    resources :photos
  end

  resources :notes do
    resources :notecomments
  end

  resources :blogs do
    resources :blogcomments
  end

  match 'following' => 'follows#following'
  match 'update_password' => 'users#update_password'
  match 'photos/modify' => 'photos#modify'
  match 'customize' => 'customizes#index'


  match 'help' => 'users#help'

  match 'recommend_blog' => 'recommend#blog'
  match 'recommend_blog' => 'recommend#blog'
  match 'recommend_note' => 'recommend#note'
  match 'recommend/modify_note' => 'recommend#modify_note'
  match 'recommend/modify_blog' => 'recommend#modify_blog'

  match 'admin' => 'admin/home#index'

  match 'register' => 'users#new'
  match 'login' => 'login#to_login'
  match 'login/login'
  match 'login/member_login'

  match 'like' => 'like#index'
  match 'editor' => 'editor#index'

  match 'follow_me' => 'follows#follow_me'
  match 'unfollow' => 'follows#unfollow_me'
  match 'edit_memoirs' => 'memoirs#edit'
  get 'edit_profile' => 'users#edit'
  match 'edit_password' => 'users#edit_password'

  
  #TODO need to changed to blog
  #match '/blo/:id' => 'blogs#view'
  #get 'note' => 'notes#index'
  #get 'diary' => 'notes#index'
  #get 'blog' => 'blogs#index'
  
  
  namespace :admin do
    
    resources :users,:notes,:blogs

    get 'logout' => 'home#logout'
    match 'profile' => 'users#edit'
    #    get 'diaries' => 'notes#index'
    #    get 'blog' => 'blogs#index'
    #    get 'note' => 'notes#index'
    #    get 'diary' => 'notes#index'
  end
  match 'profile' => 'users#show'
  match 'edit_profile' => 'users#edit'

  #This match must in below
  #match '/:username/news' => 'news#index'
  #match '/:username' => 'users#home'
  #root :to => 'users#to_login'
  root :to => 'home#index'
  
  #get tell us home/index is a router path which match controller 'home' and action 'index' and verb is get
  #get 'home/index'
  #match 'news' => 'news#index'
  #match 'news/:id' => 'news#show'
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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
