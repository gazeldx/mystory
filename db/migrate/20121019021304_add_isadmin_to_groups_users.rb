class AddIsadminToGroupsUsers < ActiveRecord::Migration
  def change
    add_column :groups_users, :is_admin, :boolean, :default => false
  end
end
