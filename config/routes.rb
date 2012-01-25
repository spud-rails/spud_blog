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
end