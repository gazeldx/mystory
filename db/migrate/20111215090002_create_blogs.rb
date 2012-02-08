class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.string :title
      t.text :content
      t.references :category
      t.references :user

      t.timestamps
    end
    add_index :blogs, :category_id
    add_index :blogs, :user_id
  end
end
