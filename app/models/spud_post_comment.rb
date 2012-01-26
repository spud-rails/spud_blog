class SpudPostComment < ActiveRecord::Base

	validates_presence_of :author, :content

end