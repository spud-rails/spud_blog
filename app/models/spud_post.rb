class SpudPost < ActiveRecord::Base
	
	has_and_belongs_to_many :categories, 
		:class_name => 'SpudPostCategory',
		:join_table => 'spud_post_categories_posts', 
		:foreign_key => 'spud_post_id'
	belongs_to :author, :class_name => 'SpudUser', :foreign_key => 'spud_user_id'
	has_many :comments, :class_name => 'SpudPostComment'

	validates_presence_of :title, :content, :published_at
end