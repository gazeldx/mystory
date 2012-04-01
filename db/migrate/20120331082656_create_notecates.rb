class CreateNotecates < ActiveRecord::Migration
  def change
    create_table :notecates do |t|
      t.string :name
      t.references :user
      t.timestamps
    end
    add_index :notecates, :user_id
  end
end
