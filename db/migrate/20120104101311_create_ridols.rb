class CreateRidols < ActiveRecord::Migration
  def change
    create_table :ridols do |t|
      t.references :user
      t.references :idol

      t.timestamps
    end
    add_index :ridols, :user_id
    add_index :ridols, :idol_id
  end
end
