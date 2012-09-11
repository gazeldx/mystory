class AddReadCommentsRecommendCountToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :views_count, :integer, :default => 0
    add_column :photos, :comments_count, :integer, :default => 0
    add_column :photos, :recommend_count, :integer, :default => 0
  end
end
