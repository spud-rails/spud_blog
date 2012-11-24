class SpudPostCommentSweeper < ActionController::Caching::Sweeper

  observe SpudPostComment

  def after_save(record)
    expire_cache_for(record)
  end

  def after_destroy(record)
    expire_cache_for(record)
  end

  private

  def expire_cache_for(record)
    unless record.post.nil?
      if Spud::Blog.config.cache_mode == :action
        if record.post.is_news
          expire_action spud_blog.news_post_url(record.post.url_name)
        else
          expire_action spud_blog.blog_post_url(record.post.url_name)
        end
      end
      if Spud::Blog.config.cache_mode == :full_page
        if record.post.is_news
          expire_page spud_blog.news_post_path(record.post.url_name)
        else
          expire_page spud_blog.blog_post_path(record.post.url_name)
        end
      end
    end
  end
end
