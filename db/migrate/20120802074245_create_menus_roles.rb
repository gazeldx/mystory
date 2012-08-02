class CreateMenusRoles < ActiveRecord::Migration
  def change
    create_table :menus_roles, :id => false do |t|
      t.references :role
      t.references :menu

      t.timestamps
    end
  end
end
