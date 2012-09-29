class AddContactToUsers < ActiveRecord::Migration
  def change
    add_column :users, :contact, :string
    add_column :users, :clicks_count, :integer, :default => 0
  end
end