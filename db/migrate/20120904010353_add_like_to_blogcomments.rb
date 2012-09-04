class AddLikeToBlogcomments < ActiveRecord::Migration
  def change
    add_column :blogcomments, :likecount, :integer, :default => 0
    add_column :blogcomments, :likeusers, :text
  end
end