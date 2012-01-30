module BlogHelper

	def spud_blog_category_select
		select_tag 'category_url_name', options_for_select(SpudPostCategory.options_for_categories(:value => :url_name), params[:category_url_name]), :include_blank => true
	end

	def spud_blog_archive_select
		dates = SpudPost.months_with_public_posts
		return select_tag 'blog_archive', options_for_select(SpudPost.months_with_public_posts.collect{ |d| 
			[d.strftime('%B %Y'), d.strftime('%Y-%b').downcase]
		}, params[:blog_archive]), :include_blank => true
	end

end