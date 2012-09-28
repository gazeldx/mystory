class CreateFboards < ActiveRecord::Migration
  def change
    create_table :fboards do |t|
      t.references :user
      t.references :board
      t.timestamps
    end
    add_index :fboards, :user_id
    add_index :fboards, :board_id
  end
end
