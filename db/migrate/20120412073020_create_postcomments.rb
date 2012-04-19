class CreatePostcomments < ActiveRecord::Migration
  def change
    create_table :postcomments do |t|
      t.text :body
      t.integer :likecount, :default => 0
      t.references :post
      t.references :user

      t.timestamps
      t.text :likeusers
    end
    add_index :postcomments, :post_id
    add_index :postcomments, :user_id
  end
end
