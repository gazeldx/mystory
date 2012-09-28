class AddCommentsCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :comments_count, :integer, :default => 0
  end
end
