class AddIsdraftToBlogs < ActiveRecord::Migration
  def change
    add_column :blogs, :is_draft, :boolean, :default => false
  end
end
