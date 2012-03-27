class CreateMemoircomments < ActiveRecord::Migration
  def change
    create_table :memoircomments do |t|
      t.text :body
      t.references :memoir
      t.references :user

      t.timestamps
    end
    add_index :memoircomments, :memoir_id
    add_index :memoircomments, :user_id
  end
end
