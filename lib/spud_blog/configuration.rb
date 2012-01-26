module Spud
  module Blog
    include ActiveSupport::Configurable
    config_accessor :default_layout, :news_enabled
    self.default_layout = 'application'
    self.news_enabled = false
  end
end
