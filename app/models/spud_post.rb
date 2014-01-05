class SpudPost < ActiveRecord::Base
	spud_searchable

	has_and_belongs_to_many :categories,
		:class_name => 'SpudPostCategory',
		:join_table => 'spud_post_categories_posts',
		:foreign_key => 'spud_post_id'
	belongs_to :author, :class_name => 'SpudUser', :foreign_key => 'spud_user_id'
	has_many :comments, :class_name => 'SpudPostComment'
	has_many :visible_comments, -> { where spam: [nil,false]}, :class_name => 'SpudPostComment'
	has_many :spam_comments, -> { where spam: true }, :class_name => "SpudPostComment"
	has_many :spud_permalinks,:as => :attachment
	has_many :spud_post_sites, :dependent => :destroy

	scope :publicly, -> { where('visible = true AND published_at <= ?', Time.now.utc).order('published_at desc') }
	scope :future_posts, -> { where('visible = true AND published_at > ?', Time.now.utc) }
	validates_presence_of :title, :content, :published_at, :spud_user_id, :url_name
	validates_uniqueness_of :url_name
	before_validation :set_url_name
	before_save :postprocess_content

	after_save :set_spud_site_ids

	attr_accessor :spud_site_ids

	def self.for_spud_site(spud_site_id)
		return joins(:spud_post_sites).where(:spud_post_sites => {:spud_site_id => spud_site_id})
	end

	def self.public_posts(page, per_page)
		return where('visible = ? AND published_at <= ?', true,Time.now.utc).order('published_at desc').includes(:categories).paginate(:page => page, :per_page => per_page)
	end

	def self.public_blog_posts(page, per_page)
		return self.public_posts(page, per_page).where(:is_news => false)
	end

	def self.public_news_posts(page, per_page)
		return self.public_posts(page, per_page).where(:is_news => true)
	end

	def self.recent_posts(limit=5)
		return where('visible = ? AND published_at <= ?', true, Time.now.utc).order('published_at desc').limit(limit)
	end

	def self.recent_blog_posts(limit=5)
		return self.recent_posts(limit).where(:is_news => false)
	end

	def self.recent_news_posts(limit=5)
		return self.recent_posts(limit).where(:is_news => true)
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
			return []
		end
	end

	def self.months_with_public_news_posts
		records = SpudPost.select('Extract(Month from published_at) as published_month, Extract(Year from published_at) as published_year').where('visible = ? AND published_at < ? AND is_news = ?', true, DateTime.now, true).group('published_month, published_year').order('published_year desc, published_month desc')
		begin
			return records.collect{ |r| Date.new(r[:published_year].to_i, r[:published_month].to_i) }
		rescue Exception => e
			logger.fatal "Exception occurred while fetching post archive dates:\n #{e.to_s}"
		end
	end

	def self.months_with_public_blog_posts
		records = SpudPost.select('Extract(Month from published_at) as published_month, Extract(Year from published_at) as published_year').where('visible = ? AND published_at < ? AND is_news = ?', true, DateTime.now, false).group('published_month, published_year').order('published_year desc, published_month desc')
		begin
			return records.collect{ |r| Date.new(r[:published_year].to_i, r[:published_month].to_i) }
		rescue Exception => e
			logger.fatal "Exception occurred while fetching post archive dates:\n #{e.to_s}"
		end
	end

	def postprocess_content
		rendererClass = Spud::Core.renderer(self.content_format)
		if rendererClass
			renderer = rendererClass.new()
			self.content_processed = renderer.render self.content
		else
			self.content_processed = content
		end
	end

	def content_processed
		if read_attribute(:content_processed).blank?
			postprocess_content
		end
		read_attribute(:content_processed)
	end

	def content_processed=(content)
		write_attribute(:content_processed,content)
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

	# Spud site ids getter
	def spud_site_ids
		if @spud_site_ids.nil?
			@spud_site_ids = spud_post_sites.collect{ |site| site.spud_site_id }
		end
		return @spud_site_ids
	end

	# Spud site ids setter
	def spud_site_ids=(site_ids)
		if site_ids.is_a?(Array)
			@spud_site_ids = site_ids.collect{ |id| id.to_i }
		else
			raise 'Site ids must be an Array'
		end
	end

	private

	def set_url_name
		self.url_name = "#{self.published_at.strftime('%Y-%m-%d')}-#{self.title.parameterize}"
	end

	def set_spud_site_ids
		if Spud::Core.multisite_mode_enabled
			_spud_post_sites = []
			self.spud_site_ids.each do |site_id|
				_spud_post_sites << SpudPostSite.new(:spud_post_id => id, :spud_site_id => site_id)
			end
			self.spud_post_sites = _spud_post_sites
		end
	end
end
