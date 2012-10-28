class AddVeiwMessageToUsers < ActiveRecord::Migration
  def change
    add_column :users, :view_messages_at, :timestamp, :default => Time.now
    add_column :users, :unread_messages_count, :integer, :default => 0
  end
end
