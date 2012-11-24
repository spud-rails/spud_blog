module BlogHelper

	def spud_post_category_select
		return select_tag 'category_url_name',
			options_for_select(SpudPostCategory.options_for_categories(:value => :url_name), params[:category_url_name]),
			:include_blank => true,
			:rel => 'category'
	end

	def spud_post_archive_select
		dates = SpudPost.months_with_public_posts
		return select_tag 'archive_date', options_for_select(SpudPost.months_with_public_posts.collect{ |d|
			[d.strftime('%B %Y'), d.strftime('%Y-%b').downcase]
		}, params[:archive_date]), :include_blank => true, :rel => 'archive'
	end

	def spud_blog_rss_link
		return tag :link, :rel => 'alternate', :type => 'application/rss+xml', :title => "#{Spud::Core.site_name} Blog RSS", :href => spud_blog.blog_url(:format => :rss)
	end

	def spud_news_rss_link
		return tag(:link, :rel => 'alternate', :type => 'application/rss+xml', :title => "#{Spud::Core.site_name} News RSS", :href => spud_blog.news_url(:format => :rss))
	end

end
