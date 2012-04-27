class CreateLetters < ActiveRecord::Migration
  def change
    create_table :letters do |t|
      t.text :body
      t.references :user
      t.references :recipient

      t.timestamps
    end
    add_index :letters, :user_id
    add_index :letters, :recipient_id
  end
end
