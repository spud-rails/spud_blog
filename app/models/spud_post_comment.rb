class SpudPostComment < ActiveRecord::Base

	validates_presence_of :author, :content
	belongs_to :post, :class_name => 'SpudPost', :foreign_key => 'spud_post_id'

	
	attr_accessible :author,:content,:spud_post_id
end