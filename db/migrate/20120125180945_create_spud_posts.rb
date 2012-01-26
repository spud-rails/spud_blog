class CreateSpudPosts < ActiveRecord::Migration
  def change
    create_table :spud_posts do |t|
      t.integer :spud_user_id
      t.string :title
      t.text :content
      t.boolean :comments_enabled, :default => 0
      t.boolean :visible, :default => 1
      t.datetime :published_at
      t.timestamps
    end
    add_index :spud_posts, :spud_user_id
    add_index :spud_posts, :visible
  end
end