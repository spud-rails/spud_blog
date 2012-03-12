class AddMetaToPosts < ActiveRecord::Migration
  def change
    add_column :spud_posts, :meta_keywords, :string
    add_column :spud_posts, :meta_description, :text
  end
end
