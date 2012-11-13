class AddNestedSetToPostCategories < ActiveRecord::Migration
  def up
    change_table :spud_post_categories do |t|
      t.integer :lft
      t.integer :rgt
      t.integer :depth
    end

    # Populates lft, rgt, and depth values for nested set
    SpudPostCategory.where(:parent_id => 0).update_all({:parent_id => nil})
    SpudPostCategory.rebuild!
  end

  def down
    change_table :spud_post_categories do |t|
      t.remove :ltf
      t.remove :rgt
      t.remove :depth
    end
  end
end
