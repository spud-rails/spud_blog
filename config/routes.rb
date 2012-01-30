Rails.application.routes.draw do

  namespace :spud do
    namespace :admin do
      resources :posts do
      	resources :post_comments, :path => 'comments', :only => :index
      end
      resources :post_comments, :except => :new
      resources :post_categories
    end
  end

  get 'blog/category/:category_url_name', :controller => 'blog', :action => 'category', :page => 1, :as => 'blog_category'
  get 'blog/category/:category_id/page/:page', :controller => 'blog', :action => 'category'
  post 'blog/category', :controller => 'blog', :action => 'category'

  get 'blog/archive/:blog_archive', :controller => 'blog', :action => 'archive', :page => 1, :as => 'blog_archive'
  get 'blog/archive/:blog_archive/page/:page', :controller => 'blog', :action => 'archive'
  post 'blog/archive', :controller => 'blog', :action => 'archive'

  get 'blog', :controller => 'blog', :action => 'index', :page => 1
  get '/blog/page/:page', :controller => 'blog', :action => 'index'
  resources :blog_posts, :path => 'blog', :controller => 'blog', :only => [:show] do
    post '/', :on => :member, :controller => 'blog', :action => 'create_comment'
  end

end