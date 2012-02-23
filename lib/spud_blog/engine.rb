require 'spud_core'
module Spud
  module Blog
    class Engine < Rails::Engine
      engine_name :spud_blog
      initializer :admin do
        Spud::Core.config.admin_applications += [{
          :name => 'Post Categories',
          :thumbnail => 'spud/admin/posts_thumb.png',
          :url => '/spud/admin/post_categories',
          :order => 3
        }]
        if Spud::Blog.enable_sitemap == true
          Spud::Core.config.sitemap_urls += [:spud_blog_sitemap_url]
        end
        if Spud::Blog.config.blog_enabled
          Spud::Core.config.admin_applications += [{
            :name => 'Blog Posts', 
            :thumbnail => 'spud/admin/posts_thumb.png',
            :url => '/spud/admin/posts',
            :order => 1
          }]
        end
        if Spud::Blog.config.news_enabled
          Spud::Core.config.admin_applications += [{
            :name => 'News Posts',
            :thumbnail => 'spud/admin/posts_thumb.png',
            :url => '/spud/admin/news_posts',
            :order => 2
          }]
        end
      end
      initializer :assets do
        Rails.application.config.assets.precompile += ['spud/admin/posts.css']
      end
      initializer :associations do
        SpudUser.class_eval do
          has_many :posts, :class_name => 'SpudPost'
        end
      end
      initializer :news_layout do
        if Spud::Core.config.news_layout.nil?
          Spud::Core.config.news_layout = Spud::Core.config.base_layout
        end
      end
    end
  end
end
