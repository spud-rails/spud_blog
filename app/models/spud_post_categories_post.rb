class SpudPostCategoriesPost < ActiveRecord::Base
  belongs_to :spud_post,:touch => true
  belongs_to :spud_post_category,:touch => true
end
