require 'spud_admin'
module Spud
  module Blog
    class Engine < Rails::Engine
      engine_name :spud_blog
      initializer :admin do
        Spud::Core.config.admin_applications += [{
          :name => 'Posts', 
          :thumbnail => 'spud/admin/posts_thumb.png',
          :url => '/spud/admin/posts',
          :order => 1
        },{
          :name => 'Post Categories',
          :thumbnail => 'spud/admin/posts_thumb.png',
          :url => '/spud/admin/post_categories',
          :order => 2
        }]
      end
      initializer :assets do
        Rails.application.config.assets.precompile += ['spud/admin/posts.css']
      end
      initializer :associations do
        SpudUser.class_eval do
          has_many :posts, :class_name => 'SpudPost'
        end
      end
    end
  end
end