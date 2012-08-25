class AddPermalinkToSpudPostComments < ActiveRecord::Migration
  def change
    add_column :spud_post_comments, :permalink, :string
  end
end
