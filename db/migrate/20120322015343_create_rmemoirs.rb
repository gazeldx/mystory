class CreateRmemoirs < ActiveRecord::Migration
  def change
    create_table :rmemoirs do |t|
      t.text :body
      t.references :user
      t.references :memoir

      t.timestamps
    end
    add_index :rmemoirs, :user_id
    add_index :rmemoirs, :memoir_id
  end
end
