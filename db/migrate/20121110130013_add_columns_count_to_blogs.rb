class AddColumnsCountToBlogs < ActiveRecord::Migration
  def change
    add_column :blogs, :columns_count, :integer, :default => 0
    add_column :notes, :columns_count, :integer, :default => 0
  end
end
