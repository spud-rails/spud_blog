module Spud::Admin::PostsHelper

	def options_for_parent_category(parent_id = 0)
		if @categories[parent_id]
			return @categories[parent_id].collect{ |c| 
				opts = [c.name, c.id] 
				opts += options_for_parent_category(c.id)
			}
		else
			return []
		end
	end

	def spud_post_site_check_box_tag(site, post)
		return check_box_tag 'spud_post[spud_site_ids][]', site[:site_id], post.spud_site_ids.include?(site[:site_id]), :id => "spud_post_site_id_#{site[:site_id]}"
	end

	def spud_post_site_label_tag(site)
		return label_tag "spud_post_site_id_#{site[:site_id]}", site[:site_name], :class => 'checkbox inline'
	end

end