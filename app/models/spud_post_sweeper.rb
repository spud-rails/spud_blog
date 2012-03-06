class SpudPostSweeper < ActionController::Caching::Sweeper
  
  observe SpudPost

  def after_save(record)
    expire_cache_for(record)
  end

  def after_destroy(record)
    expire_cache_for(record)
  end

  private

  def expire_cache_for(record)
    if Spud::Blog.config.enable_action_caching
      expire_action spud_blog_sitemap_url
      if record.is_news
        expire_action blog_url
        expire_action blog_url(:format => :rss)
        expire_action blog_post_url(record.url_name)
      else
        expire_action news_url
        expire_action news_url(:format => :rss)
        expire_action news_post_url(record.url_name)
      end
    end
    if Spud::Blog.config.enable_full_page_caching 
      expire_page spud_blog_sitemap_path
      if record.is_news
        expire_page news_path
        expire_page news_path(:format => :rss)
        expire_page news_post_path(record.url_name)
      else
        expire_page blog_path
        expire_page blog_path(:format => :rss)
        expire_page blog_post_path(record.url_name)
      end
    end

    expire_page spud_blog_sitemap_path(:format => :xml)
  end

end