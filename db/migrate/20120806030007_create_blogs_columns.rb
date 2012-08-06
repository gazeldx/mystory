class CreateBlogsColumns < ActiveRecord::Migration
  def change
    create_table :blogs_columns, :id => false do |t|
      t.references :column
      t.references :blog

      t.timestamps
    end
    add_index :blogs_columns, :column_id
    add_index :blogs_columns, :blog_id
  end
end
