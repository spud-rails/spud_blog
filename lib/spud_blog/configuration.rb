module Spud
  module Blog
    include ActiveSupport::Configurable
    config_accessor :base_layout, :blog_enabled, :news_enabled, :posts_per_page
    self.base_layout = 'application'
    self.news_enabled = false
    self.blog_enabled = true
    self.posts_per_page = 5
  end
end
