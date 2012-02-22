
xml.instruct! :xml, :version => '1.0', :encoding => 'UTF-8'

# create the urlset
xml.urlset :xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9' do
  @posts.each do |post|
    xml.url do
      if post.is_news
        xml.loc news_post_url(post)
      else
        xml.loc blog_post_url(post)
      end 
      xml.lastmod post.published_at.strftime('%Y-%m-%d')
    end
  end
end