class AddUrlToSpudPostCategories < ActiveRecord::Migration
  def change
  	add_column :spud_post_categories, :parent_id, :integer, :default => 0
  	add_column :spud_post_categories, :url_name, :string
  	add_index :spud_post_categories, :parent_id
  	add_index :spud_post_categories, :url_name
  end
end
