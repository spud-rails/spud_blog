class SpudPostCategory < ActiveRecord::Base
	has_and_belongs_to_many :posts, 
		:class_name => 'SpudPost',
		:join_table => 'spud_post_categories_posts', 
		:foreign_key => 'spud_post_category_id'
end