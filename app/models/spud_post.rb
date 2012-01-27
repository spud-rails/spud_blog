class SpudPost < ActiveRecord::Base

	has_and_belongs_to_many :categories, 
		:class_name => 'SpudPostCategory',
		:join_table => 'spud_post_categories_posts', 
		:foreign_key => 'spud_post_id'
	belongs_to :author, :class_name => 'SpudUser', :foreign_key => 'spud_user_id'
	has_many :comments, :class_name => 'SpudPostComment'

	validates_presence_of :title, :content, :published_at, :spud_user_id, :url_name
	validates_uniqueness_of :url_name
	before_validation :set_url_name

	def self.recent_posts(limit=5)
		return where('visible = 1 AND published_at <= ?', DateTime.now).order('published_at desc').limit(limit)
	end

	def display_date
		return published_at.strftime("%b %d, %Y")
	end

	def is_public?
		return (published_at < DateTime.now) && visible
	end

	def is_private?
		return !is_public?
	end

	private

	def set_url_name
		self.url_name = "#{self.published_at.strftime('%Y-%m-%d')}-#{self.title.parameterize}"
	end
end