class SpudPostSweeper < ActionController::Caching::Sweeper

  observe SpudPost

  def after_create(record)
    expire_cache_for(record)
  end

  def before_update(record)
    expire_cache_for(record)
  end

  def after_destroy(record)
    expire_cache_for(record)
  end

  private

  def expire_cache_for(record)
    if Spud::Blog.config.cache_mode == :action
      expire_action spud_blog_sitemap_url
      if !record.is_news && Spud::Blog.config.blog_enabled
        expire_action blog_url
        expire_action blog_url(:format => :rss)
        expire_action blog_post_url(record.url_name)
      elsif Spud::Blog.config.news_enabled
        expire_action news_url
        expire_action news_url(:format => :rss)
        expire_action news_post_url(record.url_name)
      end
    end
    if Spud::Blog.config.cache_mode == :full_page
      expire_page spud_blog_sitemap_path(:format => :xml)
      if record.is_news && Spud::Blog.config.news_enabled
        expire_page news_path
        expire_page news_path(:format => :rss)
        expire_page news_post_path(record.url_name)
      elsif Spud::Blog.config.blog_enabled
        expire_page blog_path
        expire_page blog_path(:format => :rss)
        expire_page blog_post_path(record.url_name)
      end
    end
    expire_page spud_sitemap_path(:format => :xml)
  end

end
