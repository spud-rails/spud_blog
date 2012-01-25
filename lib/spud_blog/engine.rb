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
        }]
      end
    end
  end
end