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
  end

  if Spud::Blog.config.blog_enabled
    scope Spud::Blog.config.blog_path do

      # Blog Post Categories
      get 'category/:category_url_name', :controller => 'blog', :action => 'category', :page => 1, :as => 'blog_category'
      get 'category/:category_url_name/page/:page', :controller => 'blog', :action => 'category'
      post 'category', :controller => 'blog', :action => 'category'

      # Blog Post Archives
      get 'archive/:archive_date', :controller => 'blog', :action => 'archive', :page => 1, :as => 'blog_archive'
      get 'archive/:archive_date/page/:page', :controller => 'blog', :action => 'archive'
      post 'archive', :controller => 'blog', :action => 'archive'

      # Blog Posts
      get '/', :controller => 'blog', :action => 'index', :page => 1, :as => 'blog'
      get 'page/:page', :controller => 'blog', :action => 'index'
      resources :blog_posts, :path => '/', :controller => 'blog', :only => [:show] do
        post '/', :on => :member, :controller => 'blog', :action => 'create_comment'
      end
    end
  end

  if Spud::Blog.config.news_enabled
    scope Spud::Blog.config.news_path do

      # News Post Categories
      get 'category/:category_url_name', :controller => 'news', :action => 'category', :page => 1, :as => 'news_category'
      get 'category/:category_url_name/page/:page', :controller => 'news', :action => 'category'
      post 'category', :controller => 'news', :action => 'category'
      
      # News Post Archives
      get 'archive/:archive_date', :controller => 'news', :action => 'archive', :page => 1, :as => 'news_archive'
      get 'archive/:archive_date/page/:page', :controller => 'news', :action => 'archive'
      post 'archive', :controller => 'news', :action => 'archive'
      
      # News Posts
      get '/', :controller => 'news', :action => 'index', :page => 1, :as => 'news'
      get 'page/:page', :controller => 'news', :action => 'index'
      resources :news_posts, :path => '/', :controller => 'news', :only => [:show]
    end
  end

end