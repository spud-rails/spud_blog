xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "#{Spud::Core.site_name} Blog Articles"
    xml.description "Blog articles for #{Spud::Core.site_name}"
    xml.link blog_url(:format => :rss)

    for article in @posts
      xml.item do
        xml.title article.title
        xml.description article.content_processed
        xml.pubDate article.created_at.to_s(:rfc822)
        xml.link blog_post_url(article.url_name)
        xml.guid blog_post_url(article.url_name)
      end
    end
  end
end
