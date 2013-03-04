Cms::Application.routes.draw do

  mount Books::Engine, :at => "/books"
  match '/feed' => 'blogs#feed', :as => :feed, :defaults => { :format => 'atom' }
  get 'ebook' => 'ebooks#txt'
  get 'query_user_columns' => 'columns#query_user_columns'
  match 'update_user_columns' => 'columns#update_user_columns'
  get 'query_article_editors' => 'columns#query_article_editors'
  get 'query_recommend_users' => 'recommend#query_recommend_users'
  get 'chat' => 'chats#index'

  resources :renjoys, :enjoys, :chats

  match 'groups/update_byuser' => 'groups#update_byuser'
  get 'about' => 'groups#about'
  
  get ':id' => 'boards#show', :constraints => { :id => /\d+/ }
  get ':id/members' => 'boards#members', :constraints => { :id => /\d+/ }
  get 'p/:id' => 'posts#show'
  get 'idols/:name' => 'idols#show'
  get 'my_posts' => 'posts#my'
  get 'my_reply' => 'posts#my_reply'
  get 'bbs' => 'posts#bbs'
  get 'bbs/reply' => 'posts#reply'
  get 'commented' => 'comments#commented'
  get 'comments' => 'comments#comments'
  get 'update_user_comments_count'  => 'comments#update_user_comments_count'
  get 'update_group_users_count'  => 'groups#update_group_users_count'
  get 'update_users_clicks_count'  => 'users#update_users_clicks_count'
  get 'update_user_schools_split'  => 'users#update_user_schools_split'

  #get 'init_users_schools_groups'  => 'users#init_users_schools_groups'#Will never been use after initialized.Can delete

  get 'archives' => 'archives#index'
  get 'archives/:month' => 'archives#month', :constraints => { :id => /\d+/ }
  #get 'notes/archives' => 'notes#archives'
  #TODO constraints LENGTH 6
  #get 'notes/archives/:month' => 'notes#month', :constraints => { :id => /\d+/ }
  #get 'blogs/archives' => 'blogs#archives'
  #TODO constraints LENGTH 6
  #get 'blogs/archives/:month' => 'blogs#month', :constraints => { :id => /\d+/ }
  
  get 'send_a_letter_to_:domain' => 'letters#new'
  get 'send_a_letter' => 'letters#new_simple'
  get 'letters/sent' => 'letters#sent'
  get 'letters/received' => 'letters#received'
  get 'as_a_writer' => 'users#as_a_writer'
  get 'signature' => 'users#signature'
  get 'edit_domain' => 'users#edit_domain'


  get 'zjtraces' => 'traces#index'
  get 'start_trace' => 'traces#start'
  get 'traces/start_trace_sina_user_one_list' => 'traces#start_trace_sina_user_one_list'
  get 'traces/start_trace_sina_user_all_list' => 'traces#start_trace_sina_user_all_list'
  get 'traces/start_trace_sina_user_two_list' => 'traces#start_trace_sina_user_two_list'
  get 'traces/start_trace_sina_users_latest_blogs' => 'traces#start_trace_sina_users_latest_blogs'
  get 'traces/clear_user_blogs' => 'traces#clear_user_blogs'

  get 's' => 'search#index'
  get 's/blogs/:title' => 'search#blogs'
  get 's/blogs' => 'search#index'
  get 's/:title' => 'search#all'

  get 'drafts' => 'drafts#index'
  get 'init_emotions' => 'emotions#init'

  get 'group_index' => 'groups#group_index'
  get 'groups/add_user_by_super'
  match 'groups/do_add_user_by_super' => 'groups#do_add_user_by_super'
  get 'groups/assign_admin'
  match 'assign_group_admin' => 'groups#do_assign_admin'
  get 'send_group_invitation' => 'groups#send_invitation'
  match 'do_send_invitation' => 'groups#do_send_invitation'
  match 'accept_group_invitation' => 'groups#accept_invitation'
  match 'gads/new'  => 'gads#new'

  resources :posts, :notes, :blogs, :follows, :memoirs, :albums, :idols, :hobbies, :customizes, :letters, :menus, :schoolnames, :messages, :groups, :gads

  resources :roles do
    member do
      get 'assign_menus'
      match 'do_assign_menus'
    end
  end

  get 'users/top'
  get 'users/recommended'
  get 'users/comments'
  match 'update_bind' => 'users#update_bind'
  resources :users do
    member do
      get 'assign_roles'
      match 'do_assign_roles'
    end
  end

  resources :columns do
    member do
      get 'up'
      get 'down'
    end
  end

  get 'column_blogs' => 'columnblogs#index'
#  get 'articles_column' => 'gcolumnarticles#index'

  resources :gcolumns do
    member do
      get 'up'
      get 'down'
    end
  end

  resources :categories do
    member do
      get 'up'
      get 'down'
    end
  end

  resources :notecates do
    member do
      get 'up'
      get 'down'
    end
  end

  resources :assortments do
    member do
      get 'up'
      get 'down'
    end
  end

  resources :boards do
    member do
      get 'follow'
    end
  end

  resources :albums do
    resources :photos do
      resources :photocomments
    end
  end

  resources :photos do
    resources :photocomments
  end

  resources :notes do
    member do
      get 'assign_columns'
      match 'do_assign_columns'
      get 'assign_gcolumns'
      match 'do_assign_gcolumns'
    end
    resources :notecomments
  end
  
  resources :blogs do
    member do
      get 'assign_columns'
      match 'do_assign_columns'
      get 'assign_gcolumns'
      match 'do_assign_gcolumns'
    end
    resources :blogcomments
  end
  get 'm_reply_blogcomment/:comment_id' => 'blogcomments#m_reply'
  get 'm_reply_notecomment/:comment_id' => 'notecomments#m_reply'
  #TODO do_m_blogcomments_reply1 name can be everything,should be modify better.
  match 'ssfsdfdsdgasgsdsdffdf' => 'blogcomments#do_m_blogcomments_reply'
  match 'ggfsdfdssdsdffsddffdf' => 'notecomments#do_m_notecomments_reply'

  get 'latest_attention' => 'blogs#latest_attention'
  get 'hotest' => 'blogs#hotest'
  get 'latest' => 'blogs#latest'


  resources :memoirs do
    resources :memoircomments
  end

  resources :posts do
    resources :postcomments
  end

  match 'following' => 'follows#following'
  match 'followers' => 'follows#followers'
  
  match 'photos/modify' => 'photos#modify'
  match 'customize' => 'customizes#index'
 

  get 'help' => 'users#help'

  match 'recommend_blog' => 'recommend#blog'
  match 'recommend_note' => 'recommend#note'
  match 'recommend_photo' => 'recommend#photo'
  match 'recommend_memoir' => 'recommend#memoir'
  match 'like_post_comment' => 'postcomments#like'
  match 'like_blog_comment' => 'blogcomments#like'
  match 'like_note_comment' => 'notecomments#like'
  match 'like_photo_comment' => 'photocomments#like'
  match 'like_memoir_comment' => 'memoircomments#like'
  get 'portal_show_more' => 'home#portal_show_more'
  

  match 'recommend/modify_note' => 'recommend#modify_note'
  match 'recommend/modify_blog' => 'recommend#modify_blog'
  match 'recommend/modify_photo' => 'recommend#modify_photo'
  match 'recommend/modify_memoir' => 'recommend#modify_memoir'

  match 'editor_blog' => 'editor#blog'
  match 'editor_note' => 'editor#note'

  match 'society_admin' => 'groups#admin'
  match 'admin' => 'admin/home#index'

  match 'register' => 'users#new'
  match 'login' => 'login#to_login'
  match 'login/login'
  match 'login/member_login'
  match 'login/bind_weibo_login'
  match 'login/bind_qq_login'


  match 'like' => 'like#index'
  match 'now' => 'now#index'
  match 'editor' => 'editor#index'

  match 'follow_me' => 'follows#follow_me'
  match 'unfollow' => 'follows#unfollow_me'


  match 'edit_memoirs' => 'memoirs#edit'
  get 'edit_profile' => 'users#edit'
  get 'edit_about' => 'groups#edit_about'
  get 'select_albums' => 'albums#select_albums'
  get 'select_photos/:album_id' => 'albums#select_photos'
  get 'tags/:name' => 'tags#show'
  get 'tags' => 'tags#index'
  #get 'tags/:name/:user_id' => 'tags#show'
  get 'click_show_blog' => 'blogs#click_show_blog'
  get 'click_show_note' => 'notes#click_show_note'

  get 'love-zhangtingting' => 'blogs#lovezhangtingting'

  #  match 'select_photos' => 'albums#select_photos'

  get 'edit_password' => 'users#edit_password'
  match 'update_password' => 'users#update_password'
  match 'update_signature' => 'users#update_signature'
  match 'update_domain' => 'users#update_domain'

  get 'weibo_connect' => 'weibo#connect'
  get 'weibo_callback' => 'weibo#callback'
  get 'weibo_account' => 'weibo#weibo_account'
  get 'cancel_weibo_bind' => 'weibo#cancel_weibo_bind'
  match 'weibo_create_account' => 'weibo#create_account'

  get 'qq_connect' => 'qq#connect'
  get 'qq_callback' => 'qq#callback'
  get 'qq_account' => 'qq#qq_account'
  get 'cancel_qq_bind' => 'qq#cancel_qq_bind'
  match 'qq_create_account' => 'qq#create_account'
  
#  get 'weibo_user' => 'weibo#weibo_user'

  
  get 'logout' => 'home#logout'
  get 'autobiography' => 'memoirs#index'
  get 'autobiographies' => 'memoirs#portal'
  
  #TODO need to changed to blog
  #match '/blo/:id' => 'blogs#view'
  #get 'note' => 'notes#index'
  #get 'diary' => 'notes#index'
  #get 'blog' => 'blogs#index'
  
  
  namespace :admin do
    
    resources :users,:notes,:blogs

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

  #Next are mobile version used
  get 'notice' => 'home#notice'
  get 'upload_photo' => 'photos#m_new'
  #get 'photo_uploaded' => 'photos#photo_uploaded'
  match 'm_upload_photo' => 'photos#m_upload_photo'
  match 'm_update_photo' => 'photos#m_update_photo'
  match 'create_letter' => 'letters#create_letter'

  get 'my' => 'my/home#index'

  #mail
  get 'new_function_email'  => 'mails#new_function_email'
  get 'note_21days_email'  => 'mails#note_21days_email'


  #temp routes
  get 'update_follow_count'  => 'follows#update_follow_count'
  
  
#  namespace :cy do

    #resources :users,:notes,:blogs
#  end
  
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
  match '*a', :to => 'errors#routing'
end
