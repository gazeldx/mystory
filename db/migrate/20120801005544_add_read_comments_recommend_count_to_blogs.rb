class AddReadCommentsRecommendCountToBlogs < ActiveRecord::Migration
  def change
    add_column :blogs, :views_count, :integer, :default => 0
    add_column :blogs, :comments_count, :integer, :default => 0
    add_column :blogs, :recommend_count, :integer, :default => 0
  end
end
