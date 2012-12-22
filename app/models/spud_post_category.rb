class SpudPostCategory < ActiveRecord::Base
	searchable
	acts_as_nested_set

	has_and_belongs_to_many :posts,
		:class_name => 'SpudPost',
		:join_table => 'spud_post_categories_posts',
		:foreign_key => 'spud_post_category_id'

	validates_presence_of :name, :url_name
	validates_uniqueness_of :name, :url_name
	before_validation :set_url_name

	before_destroy :update_child_categories

	attr_accessible :name, :url_name, :parent_id

	# tell awesome_nested_set not to destroy descendants
	def skip_before_destroy
		return true
	end

	def self.grouped
		return all.group_by(&:parent_id)
	end

	# Returns an array of categories in order of heirarchy
	# 	:fitler Filters out a category by ID, and all of its children
	#   :value Pick an attribute to be used in the value field, defaults to ID
	def self.options_for_categories(config={})
		collection = config[:collection] || self.grouped
		level 		 = config[:level] 		 || 0
		parent_id  = config[:parent_id]  || nil
		filter 		 = config[:filter] 		 || nil
		value      = config[:value]			 || :id
		list 			 = []
		if collection[parent_id]
			collection[parent_id].each do |c|
				if c.id != filter
					list << [level.times.collect{ '- ' }.join('') + c.name, c[value]]
					list += self.options_for_categories({:collection => collection, :parent_id => c.id, :level => level+1, :filter => filter, :value => value})
				end
			end
		end
		return list
	end

	def posts_with_children
		category_ids = self.self_and_descendants.collect{ |category| category.id }

		post_ids = SpudPostCategoriesPost.where(:spud_post_category_id => category_ids).collect{ |it| it.spud_post_id  }
		return SpudPost.where(:id => post_ids)
	end

	private

	def set_url_name
		self.url_name = self.name.parameterize if !self.name.blank?
	end

	def update_child_categories
		self.children.update_all(:parent_id => self.parent_id)
		self.class.rebuild!
	end
end
