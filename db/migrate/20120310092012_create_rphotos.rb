class CreateRphotos < ActiveRecord::Migration
  def change
    create_table :rphotos do |t|
      t.text :body
      t.references :user
      t.references :photo

      t.timestamps
    end
    add_index :rphotos, :user_id
    add_index :rphotos, :photo_id
  end
end
