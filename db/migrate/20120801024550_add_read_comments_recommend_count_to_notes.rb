class AddReadCommentsRecommendCountToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :views_count, :integer, :default => 0
    add_column :notes, :comments_count, :integer, :default => 0
    add_column :notes, :recommend_count, :integer, :default => 0
  end
end
