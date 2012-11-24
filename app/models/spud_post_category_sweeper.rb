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
    if Spud::Blog.config.cache_mode = :action
      SpudPost.find_each do |p|
        if p.is_news && Spud::Blog.config.news_enabled
          expire_action spud_blog.news_post_url(p.url_name)
        elsif Spud::Blog.config.blog_enabled
          expire_action spud_blog.blog_post_url(p.url_name)
        end
      end
      expire_action spud_blog.news_url if Spud::Blog.config.news_enabled
      expire_action spud_blog.blog_url if Spud::Blog.config.blog_enabled
      expire_action spud_core.blog_sitemap_url
    end
    if Spud::Blog.config.cache_mode = :full_page
      SpudPost.find_each do |p|
        if p.is_news && Spud::Blog.config.news_enabled
          expire_page spud_blog.news_post_path(p.url_name)
        elsif Spud::Blog.config.blog_enabled
          expire_page spud_blog.blog_post_path(p.url_name)
        end
      end
      expire_page spud_blog.news_path if Spud::Blog.config.news_enabled
      expire_page spud_blog.blog_path if Spud::Blog.config.blog_enabled
      expire_page spud_core.blog_sitemap_path(:format => :xml)
    end
  end
end
