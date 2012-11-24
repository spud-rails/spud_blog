module Spud
  module Blog
    include ActiveSupport::Configurable
    config_accessor(
      :base_layout, :news_layout, :blog_enabled,
      :news_enabled, :posts_per_page, :blog_path,
      :news_path, :enable_sitemap, :has_custom_fields,
      :cache_mode, :action_caching_duration, :automount,
      :enable_rakismet
    )

    self.automount = true
    self.base_layout = 'application'
    self.news_layout = nil
    self.news_enabled = false
    self.blog_enabled = true
    self.posts_per_page = 5
    self.blog_path = 'blog'
    self.news_path = 'news'
    self.enable_sitemap = true
    self.has_custom_fields = false
    self.cache_mode = nil #options :full_page, :action
    self.action_caching_duration = 3600
    self.enable_rakismet = false
  end
end
