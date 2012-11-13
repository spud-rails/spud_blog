class SpudPostCategoriesPost < ActiveRecord::Base
  attr_accessible :spud_post_id, :spud_post_category_id
  belongs_to :spud_post
  belongs_to :spud_post_category
end