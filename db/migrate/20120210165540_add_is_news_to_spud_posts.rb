class AddIsNewsToSpudPosts < ActiveRecord::Migration
  def change
  	add_column :spud_posts, :is_news, :boolean, :default => 0
  	add_index :spud_posts, :is_news
  end
end
