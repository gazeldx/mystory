class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :stype, :default => 0
      t.text :body
      t.string :parameters
      t.references :user

      t.timestamps
    end
    add_index :messages, :user_id
  end
end
