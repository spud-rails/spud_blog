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

  get 'blog/category/:category_url_name', :controller => 'blog', :action => 'category', :page => 1, :as => 'blog_category'
  get 'blog/category/:category_url_name/page/:page', :controller => 'blog', :action => 'category'
  post 'blog/category', :controller => 'blog', :action => 'category'

  get 'blog/archive/:archive_date', :controller => 'blog', :action => 'archive', :page => 1, :as => 'blog_archive'
  get 'blog/archive/:archive_date/page/:page', :controller => 'blog', :action => 'archive'
  post 'blog/archive', :controller => 'blog', :action => 'archive'

  get 'blog', :controller => 'blog', :action => 'index', :page => 1
  get '/blog/page/:page', :controller => 'blog', :action => 'index'
  resources :blog_posts, :path => 'blog', :controller => 'blog', :only => [:show] do
    post '/', :on => :member, :controller => 'blog', :action => 'create_comment'
  end

  get 'news/category/:category_url_name', :controller => 'news', :action => 'category', :page => 1, :as => 'news_category'
  get 'news/category/:category_url_name/page/:page', :controller => 'news', :action => 'category'
  post 'news/category', :controller => 'news', :action => 'category'
  
  get 'news/archive/:archive_date', :controller => 'news', :action => 'archive', :page => 1, :as => 'news_archive'
  get 'news/archive/:archive_date/page/:page', :controller => 'news', :action => 'archive'
  post 'news/archive', :controller => 'news', :action => 'archive'
  
  get 'news', :controller => 'news', :action => 'index', :page => 1
  get '/news/page/:page', :controller => 'news', :action => 'index'
  resources :news_posts, :path => 'news', :controller => 'news', :only => [:show]

end