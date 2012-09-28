class AddCountEtcToUsers < ActiveRecord::Migration
  def change
    add_column :users, :followers_num, :integer, :default => 0
    add_column :users, :following_num, :integer, :default => 0
    add_column :users, :blogs_count, :integer, :default => 0
    add_column :users, :notes_count, :integer, :default => 0
    add_column :users, :photos_count, :integer, :default => 0
  end
end
