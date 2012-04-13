class AddCommentsCounterToSpudPosts < ActiveRecord::Migration
  def self.up
    add_column :spud_posts, :comments_count, :integer, :default => 0
    SpudPost.find_each do |post|
      post.comments_count = post.comments.count
      post.save
    end
  end
  def self.down
    remove_column :spud_posts, :comments_count
  end
end