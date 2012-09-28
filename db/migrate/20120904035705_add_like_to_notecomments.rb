class AddLikeToNotecomments < ActiveRecord::Migration
  def change
    add_column :notecomments, :likecount, :integer, :default => 0
    add_column :notecomments, :likeusers, :text
  end
end
