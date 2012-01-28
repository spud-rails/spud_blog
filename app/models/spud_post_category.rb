class SpudPostCategory < ActiveRecord::Base
	has_and_belongs_to_many :posts,
		:class_name => 'SpudPost',
		:join_table => 'spud_post_categories_posts',
		:foreign_key => 'spud_post_category_id'

	has_many :children, :class_name => 'SpudPostCategory', :foreign_key => 'parent_id'
	validates_presence_of :name, :url_name
	before_validation :set_url_name

	scope :top_level, where(:parent_id => 0).order('name asc')

	def self.grouped
		return all.group_by(&:parent_id)
	end

	def self.options_for_categories(collection=nil, parent_id=0, level=0)
		if collection.nil?
			collection = self.grouped
		end
		list = []
		if collection[parent_id]
			collection[parent_id].each do |c|
				list << [level.times.collect{ '- ' }.join('') + c.name, c.id]
				list += self.options_for_categories(collection, c.id, level+1)
			end
		end
		return list
	end

	private

	def set_url_name
		self.url_name = self.name.parameterize
	end
end