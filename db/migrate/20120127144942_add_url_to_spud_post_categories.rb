class AddUrlToSpudPostCategories < ActiveRecord::Migration
  def change
  	add_column :spud_post_categories, :parent_id, :integer
  	add_column :spud_post_categories, :url, :string
  	add_index :spud_post_categories, :url
  	add_index :spud_post_categories, :parent_id
  end
end
