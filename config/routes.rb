Rails.application.routes.draw do
  namespace :spud do
    namespace :admin do
      resources :posts
    end
  end
end