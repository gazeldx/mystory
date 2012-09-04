class AddLikeToPhotocomments < ActiveRecord::Migration
  def change
    add_column :photocomments, :likecount, :integer, :default => 0
    add_column :photocomments, :likeusers, :text
  end
end
