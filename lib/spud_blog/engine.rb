require 'spud_core'
require 'awesome_nested_set'
require 'spud_permalinks'
require 'truncate_html'

module Spud
  module Blog
    class Engine < Rails::Engine

      def self.require_model(model_name)
        require "#{root}/app/models/#{model_name}"
      end

      def self.require_controller(controller_name)
        require "#{root}/app/controllers/#{controller_name}"
      end

      engine_name :spud_blog
      initializer :admin do
        if Spud::Blog.enable_sitemap == true
          Spud::Core.config.sitemap_urls += [:spud_blog_sitemap_url]
        end
        if Spud::Blog.config.blog_enabled
          Spud::Core.config.admin_applications += [{
            :name => 'Blog Posts',
            :thumbnail => 'spud/admin/posts_thumb.png',
            :url => {:controller => '/spud/admin/posts'},
            :order => 1
          }]
        end
        if Spud::Blog.config.news_enabled
          Spud::Core.config.admin_applications += [{
            :name => 'News Posts',
            :thumbnail => 'spud/admin/news_thumb.png',
            :url => {:controller => '/spud/admin/news_posts'},
            :order => 2
          }]
        end
      end
      initializer :assets do
        Rails.application.config.assets.precompile += ['spud/admin/posts.css','spud/blog/validity.css']
        Spud::Core.append_admin_javascripts('spud/admin/posts')
        Spud::Core.append_admin_stylesheets('spud/admin/posts')
      end
      initializer :associations do
        Spud::Core::Engine.user_model.class_eval do
          has_many :posts, :class_name => 'SpudPost', :foreign_key => :spud_user_id
        end
      end
      initializer :news_layout do
        if Spud::Core.config.news_layout.nil?
          Spud::Core.config.news_layout = Spud::Core.config.base_layout
        end
      end

      initializer :rakismet do
        if Spud::Blog.enable_rakismet
          require 'rakismet'
        end
      end
    end
  end
end
