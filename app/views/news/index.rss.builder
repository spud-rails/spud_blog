xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "#{Spud::Core.site_name} News"
    xml.description "News articles for #{Spud::Core.site_name}"
    xml.link news_url(:format => :rss)

    for article in @posts
      xml.item do
        xml.title article.title
        xml.description article.content_processed
        xml.pubDate article.created_at.to_s(:rfc822)
        xml.link news_post_url(article.url_name)
        xml.guid news_post_url(article.url_name)
      end
    end
  end
end
