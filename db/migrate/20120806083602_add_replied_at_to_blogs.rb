class AddRepliedAtToBlogs < ActiveRecord::Migration
  def change
    add_column :blogs, :replied_at, :timestamp
  end
end
