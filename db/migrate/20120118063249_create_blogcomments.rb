class CreateBlogcomments < ActiveRecord::Migration
  def change
    create_table :blogcomments do |t|
      t.text :body
      t.references :blog
      t.references :user

      t.timestamps
    end
    add_index :blogcomments, :blog_id
    add_index :blogcomments, :user_id
  end
end
