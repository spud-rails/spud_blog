class AddContentFormatToSpudPosts < ActiveRecord::Migration
  def change
    add_column :spud_posts, :content_format, :string, :default => "HTML"
  end
end
