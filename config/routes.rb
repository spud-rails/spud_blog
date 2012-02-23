Rails.application.routes.draw do

  namespace :spud do
    namespace :admin do
      resources :posts do
      	resources :post_comments, :path => 'comments', :only => :index
      end
      resources :news_posts
      resources :post_comments, :except => :new
      resources :post_categories
    end
    namespace :blog do
      resource :sitemap,:only => "show"
    end
  end

  if Spud::Blog.config.blog_enabled
    scope Spud::Blog.config.blog_path do

      # Blog Post Categories
      get 'category/:category_url_name(/page/:page)', 
        :controller => 'blog', 
        :action => 'category',  
        :as => 'blog_category',
        :defaults => {:page => 1}
      get 'category/:category_url_name/:archive_date(/page/:page)', 
        :controller => 'blog', 
        :action => 'category', 
        :as => 'blog_category_archive',
        :defaults => {:page => 1}

      # Blog Post Archives
      get 'archive/:archive_date(/page/:page)', 
        :controller => 'blog', 
        :action => 'archive', 
        :as => 'blog_archive',
        :defaults => {:page => 1}

      # Category/Archive filtering
      post '/', :controller => 'blog', :action => 'filter'

      # Blog Posts
      get '/(page/:page)', 
        :controller => 'blog', 
        :action => 'index',
        :as => 'blog',
        :defaults => {:page => 1}
      resources :blog_posts, :path => '/', :controller => 'blog', :only => [:show] do
        post '/', :on => :member, :controller => 'blog', :action => 'create_comment'
      end
    end
  end

  if Spud::Blog.config.news_enabled
    scope Spud::Blog.config.news_path do

      # News Post Categories
      get 'category/:category_url_name(/page/:page)', 
        :controller => 'news', 
        :action => 'category',
        :as => 'news_category',
        :defaults => {:page => 1}
      get 'category/:category_url_name/:archive_date(/page/:page)', 
        :controller => 'news', 
        :action => 'category', 
        :as => 'news_category_archive',
        :defaults => {:page => 1}
      
      # News Post Archives
      get 'archive/:archive_date(/page/:page)', 
        :controller => 'news',
        :action => 'archive', 
        :as => 'news_archive',
        :defaults => {:page => 1}

      # Category/Archive filtering
      post '/', :controller => 'news', :action => 'filter'
      
      # News Posts
      get '/(page/:page)', 
        :controller => 'news', 
        :action => 'index', 
        :as => 'news',
        :defaults => {:page => 1}
      resources :news_posts, :path => '/', :controller => 'news', :only => [:show]
    end
  end

end