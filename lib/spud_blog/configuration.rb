module Spud
  module Blog
    include ActiveSupport::Configurable
    config_accessor :base_layout, :blog_enabled, :news_enabled
    self.base_layout = 'application'
    self.news_enabled = false
    self.blog_enabled = true
  end
end
