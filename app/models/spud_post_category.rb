class SpudPostCategory < ActiveRecord::Base

	has_and_belongs_to_many :posts,
		:class_name => 'SpudPost',
		:join_table => 'spud_post_categories_posts',
		:foreign_key => 'spud_post_category_id'
	has_many :children, :class_name => 'SpudPostCategory', :foreign_key => 'parent_id'
	
	validates_presence_of :name, :url_name
	validates_uniqueness_of :name, :url_name
	validate :parent_is_valid
	before_validation :set_url_name

	before_destroy :update_child_categories

	scope :top_level, where(:parent_id => 0).order('name asc')

	def self.grouped
		return all.group_by(&:parent_id)
	end

	# Returns an array of categories in order of heirarchy
	# 	:fitler Filters out a category by ID, and all of its children
	#   :value Pick an attribute to be used in the value field, defaults to ID
	def self.options_for_categories(config={})
		collection = config[:collection] || self.grouped
		level 		 = config[:level] 		 || 0
		parent_id  = config[:parent_id]  || 0
		filter 		 = config[:filter] 		 || nil
		value      = config[:value]			 || :id
		list 			 = []
		if collection[parent_id]
			collection[parent_id].each do |c|
				if c.id != filter
					list << [level.times.collect{ '- ' }.join('') + c.name, c[value]]
					list += self.options_for_categories({:collection => collection, :parent_id => c.id, :level => level+1, :filter => filter})
				end
			end
		end
		return list
	end

	private

	def set_url_name
		self.url_name = self.name.parameterize
	end

	def parent_is_valid
		if parent_id == self.id
			errors.add :base, 'Category cannot be its own parent'
		end
	end

	def update_child_categories
		self.children.update_all(:parent_id => self.parent_id)
	end
end