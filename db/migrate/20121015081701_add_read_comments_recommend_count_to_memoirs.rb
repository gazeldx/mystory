class AddReadCommentsRecommendCountToMemoirs < ActiveRecord::Migration
  def change
    add_column :memoirs, :views_count, :integer, :default => 0
    add_column :memoirs, :comments_count, :integer, :default => 0
    add_column :memoirs, :recommend_count, :integer, :default => 0
  end
end
