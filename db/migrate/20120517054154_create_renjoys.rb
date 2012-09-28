class CreateRenjoys < ActiveRecord::Migration
  def change
    create_table :renjoys do |t|
      t.references :user
      t.references :enjoy

      t.timestamps
    end
    add_index :renjoys, :user_id
    add_index :renjoys, :enjoy_id
  end
end
