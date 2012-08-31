class ChangeWeiboidToUsers < ActiveRecord::Migration
  #  def up
  #  end
  #
  #  def down
  #  end
  def change
    change_column :users, :weiboid, :string
  end
end
