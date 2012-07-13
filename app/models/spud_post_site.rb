class SpudPostSite < ActiveRecord::Base
  attr_accessible :spud_post_id, :spud_site_id
  belongs_to :spud_post

  def spud_site
    return Spud::Core.site_config_for_id(spud_site_id)
  end
  
end
