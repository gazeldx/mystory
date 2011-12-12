class CreateParams < ActiveRecord::Migration
  def change
    create_table :params do |t|
      t.string :sitename
      t.string :memo
      t.string :logo
      t.string :teldesc
      t.references :user

      t.timestamps
    end
    add_index :params, :user_id
  end
end
