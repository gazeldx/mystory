class CreateMemoirs < ActiveRecord::Migration
  def change
    create_table :memoirs do |t|
      t.string :title
      t.text :content
      t.references :user

      t.timestamps
    end
    add_index :memoirs, :user_id
  end
end
