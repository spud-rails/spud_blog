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

  match 'blog/categories/:category_id', :controller => 'blog', :action => 'index', :page => 1, :as => 'blog_category'
  match 'blog/categories/:category_id/page/:page', :controller => 'blog', :action => 'index'

  match 'blog', :controller => 'blog', :action => 'index', :page => 1
  match '/blog/page/:page', :controller => 'blog', :action => 'index'
  resources :blog_posts, :path => 'blog', :controller => 'blog', :only => [:show] do
    post '/', :on => :member, :controller => 'blog', :action => 'create_comment'
  end

	# match 'news', :controller => 'posts', :action => 'index', :page => 1
	# match '/news/page/:page', :controller => 'posts', :action => 'index'
	# resources :news_posts, :path => 'news', :controller => 'posts', :only => ['index', 'show']

end