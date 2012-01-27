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

end