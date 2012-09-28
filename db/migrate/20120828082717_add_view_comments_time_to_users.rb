class AddViewCommentsTimeToUsers < ActiveRecord::Migration
  
  def change
    add_column :users, :view_comments_at, :timestamp
    add_column :users, :view_commented_at, :timestamp
    add_column :users, :unread_comments_count, :integer, :default => 0
    add_column :users, :unread_commented_count, :integer, :default => 0
  end
end
