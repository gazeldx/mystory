class CreateAssortments < ActiveRecord::Migration
  def change
    create_table :assortments do |t|
      t.string :name
      t.references :user

      t.timestamps
    end
    add_index :assortments, :user_id
  end
end
