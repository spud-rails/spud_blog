class SpudPostCategory < ActiveRecord::Base
	has_and_belongs_to_many :posts,
		:class_name => 'SpudPost',
		:join_table => 'spud_post_categories_posts',
		:foreign_key => 'spud_post_category_id'

	validates_presence_of :name
	before_save :set_url

	private

	def set_url
		self.url = self.name.parameterize
	end
end