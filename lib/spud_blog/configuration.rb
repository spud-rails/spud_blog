module Spud
  module Blog
    include ActiveSupport::Configurable
    config_accessor :base_layout, :news_enabled
    self.base_layout = 'application'
    self.news_enabled = false
  end
end
