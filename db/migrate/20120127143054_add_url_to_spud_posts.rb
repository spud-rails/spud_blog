class AddUrlToSpudPosts < ActiveRecord::Migration
  def change
  	add_column :spud_posts, :url, :string
  	add_index :spud_posts, :url
  end
end
