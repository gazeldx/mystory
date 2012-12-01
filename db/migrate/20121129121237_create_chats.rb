class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.references :group
      t.references :user
      t.text :body

      t.timestamps
    end
    add_index :chats, :group_id
    add_index :chats, :user_id
  end
end
