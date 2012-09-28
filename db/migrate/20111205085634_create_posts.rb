class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.references :board
      t.references :user
      t.timestamp :replied_at
      t.timestamps
    end
  end
end
