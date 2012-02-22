class SpudPost < ActiveRecord::Base

	searchable
	has_and_belongs_to_many :categories, 
		:class_name => 'SpudPostCategory',
		:join_table => 'spud_post_categories_posts', 
		:foreign_key => 'spud_post_id'
	belongs_to :author, :class_name => 'SpudUser', :foreign_key => 'spud_user_id'
	has_many :comments, :class_name => 'SpudPostComment'

	validates_presence_of :title, :content, :published_at, :spud_user_id, :url_name
	validates_uniqueness_of :url_name
	before_validation :set_url_name

	def self.public_posts(page, per_page)
		return where('visible = ? AND published_at <= ?', true, DateTime.now).order('published_at desc').includes(:comments, :categories).paginate(:page => page, :per_page => per_page)
	end

	def self.public_blog_posts(page, per_page)
		return self.public_posts(page, per_page).where(:is_news => false)
	end

	def self.public_news_posts(page, per_page)
		return self.public_posts(page, per_page).where(:is_news => true)
	end

	def self.recent_posts(limit=5)
		return where('visible = ? AND published_at <= ?', true, DateTime.now).order('published_at desc').limit(limit)
	end

	def self.recent_blog_posts(limit=5)
		return self.recent_posts.where(:is_news => false)
	end

	def self.recent_news_posts(limit=5)
		return self.recent_posts.where(:is_news => true)
	end

	def self.from_archive(date_string)
		begin
			date = Date.strptime(date_string, "%Y-%b")
			return where(:published_at => date..date.end_of_month)
		rescue
			return all
		end
	end

	#def self.posts_for_category_archive(category, )

 	# Returns an array of Date objects for months with public posts
	def self.months_with_public_posts
		# Select 
		# 	Month(published_at) as published_month,
		# 	Year(published_at) as published_year
		# From spud_posts
		# Where visible = 1
		# And published_at < '2012-01-30'
		# Group By published_month, published_year
		# Order By published_year desc, published_month desc
		records = SpudPost.select('Extract(Month from published_at) as published_month, Extract(Year from published_at) as published_year').where('visible = ? AND published_at < ?', true, DateTime.now).group('published_month, published_year').order('published_year desc, published_month desc')
		begin
			return records.collect{ |r| Date.new(r[:published_year].to_i, r[:published_month].to_i) }
		rescue Exception => e
			logger.fatal "Exception occurred while fetching post archive dates:\n #{e.to_s}"
		end
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