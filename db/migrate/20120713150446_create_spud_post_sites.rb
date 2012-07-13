class CreateSpudPostSites < ActiveRecord::Migration
  def change
    create_table :spud_post_sites do |t|
      t.integer :spud_post_id, :null => false
      t.integer :spud_site_id, :null => false
      t.timestamps
    end
    add_index :spud_post_sites, :spud_post_id
    add_index :spud_post_sites, :spud_site_id  
  end
end
