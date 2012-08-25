class SpudPostComment < ActiveRecord::Base
  if Spud::Blog.enable_rakismet
    include Rakismet::Model
    before_save :rakismet_check_for_spam
  end


	validates_presence_of :author, :content
	belongs_to :post, :class_name => 'SpudPost', :foreign_key => 'spud_post_id', :counter_cache => :comments_count

	attr_accessible :author,:content,:spud_post_id,:referrer,:spam,:user_agent,:user_ip,:permalink


  def rakismet_check_for_spam
    self.spam = self.spam?
    return true
  end

end
