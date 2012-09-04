class AddLikeToMemoircomments < ActiveRecord::Migration
  def change
    add_column :memoircomments, :likecount, :integer, :default => 0
    add_column :memoircomments, :likeusers, :text
  end
end
