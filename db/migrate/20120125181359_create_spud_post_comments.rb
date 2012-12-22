class CreateSpudPostComments < ActiveRecord::Migration
  def change
    create_table :spud_post_comments do |t|
      t.integer :spud_post_id
      t.string :author
      t.text :content
      t.boolean :approved, :default => false
      t.timestamps
    end
    add_index :spud_post_comments, :spud_post_id, :name => "idx_comment_post_id"
    add_index :spud_post_comments, :approved, :name => "idx_comment_approved"
  end
end
