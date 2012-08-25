class AddSpamFieldsToSpudPostComments < ActiveRecord::Migration
  def change
    add_column :spud_post_comments, :spam, :boolean
    add_column :spud_post_comments, :user_ip, :string
    add_column :spud_post_comments, :user_agent, :string
    add_column :spud_post_comments, :referrer, :string
  end
end
