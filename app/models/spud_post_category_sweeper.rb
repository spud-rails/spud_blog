class SpudPostCategorySweeper < ActionController::Caching::Sweeper

  observe SpudPostCategory

  def after_save(record)
    expire_cache_for(record)
  end

  def after_destroy(record)
    expire_cache_for(record)
  end

  private

  def expire_cache_for(record)
    if Spud::Blog.config.enable_action_caching
      SpudPost.find_each do |p|
        if p.is_news && Spud::Blog.config.news_enabled
          expire_action news_post_url(p.url_name)
        elsif Spud::Blog.config.blog_enabled
          expire_action blog_post_url(p.url_name)
        end
      end
      expire_action news_url if Spud::Blog.config.news_enabled
      expire_action blog_url if Spud::Blog.config.blog_enabled
      expire_action spud_blog_sitemap_url
    end
    if Spud::Blog.config.enable_full_page_caching
      SpudPost.find_each do |p|
        if p.is_news && Spud::Blog.config.news_enabled
          expire_page news_post_path(p.url_name)
        elsif Spud::Blog.config.blog_enabled
          expire_page blog_post_path(p.url_name)
        end
      end
      expire_page news_path if Spud::Blog.config.news_enabled
      expire_page blog_path if Spud::Blog.config.blog_enabled
      expire_page spud_blog_sitemap_path(:format => :xml)
    end
  end
end