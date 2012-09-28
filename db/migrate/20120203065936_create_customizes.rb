class CreateCustomizes < ActiveRecord::Migration
  def change
    create_table :customizes do |t|
      t.string :bgimage
      t.references :user

      t.timestamps
    end
    add_index :customizes, :user_id
  end
end
