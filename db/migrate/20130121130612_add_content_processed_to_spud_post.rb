class AddContentProcessedToSpudPost < ActiveRecord::Migration
  def change
    add_column :spud_posts, :content_processed, :text
  end
end
