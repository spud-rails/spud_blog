class AddUrlToSpudPosts < ActiveRecord::Migration
  def change
  	add_column :spud_posts, :url_name, :string
  	add_index :spud_posts, :url_name
  end
end
