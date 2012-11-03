class AddUseridToColumns < ActiveRecord::Migration
  def change
    add_column :columns, :user_id, :integer
  end
end
