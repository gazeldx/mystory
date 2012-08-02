class CreateRolesUsers < ActiveRecord::Migration
  def change
    create_table :roles_users, :id => false do |t|
      t.references :user
      t.references :role

      t.timestamps
    end
    add_index :roles_users, :user_id
  end
end
