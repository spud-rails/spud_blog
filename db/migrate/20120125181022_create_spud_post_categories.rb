class CreateSpudPostCategories < ActiveRecord::Migration
  def change
    create_table :spud_post_categories do |t|
      t.string :name
      t.timestamps
    end
    create_table :spud_post_categories_posts, :id => false do |t|
    	t.integer :spud_post_id
    	t.integer :spud_post_category_id
    end
    add_index :spud_post_categories_posts, :spud_post_category_id, :name => "idx_category_id"
  end
end
