class AddWeiboidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :weiboid, :integer
  end
end
