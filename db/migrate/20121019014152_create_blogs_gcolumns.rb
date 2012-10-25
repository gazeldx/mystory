class CreateBlogsGcolumns < ActiveRecord::Migration
  def change
    create_table :blogs_gcolumns, :id => false do |t|
      t.references :gcolumn
      t.references :blog

      t.timestamp :created_at
    end
    add_index :blogs_gcolumns, :gcolumn_id
    add_index :blogs_gcolumns, :blog_id
  end
end
