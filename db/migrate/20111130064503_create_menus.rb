class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.string :name
      t.string :url
      t.string :description
      t.references :user

      t.timestamps
    end
    add_index :menus, :user_id
  end
end
