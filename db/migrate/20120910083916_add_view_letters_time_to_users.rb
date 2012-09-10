class AddViewLettersTimeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :view_letters_at, :timestamp
    add_column :users, :unread_letters_count, :integer, :default => 0
  end
end
