class AddWeiboTokenSecretToUsers < ActiveRecord::Migration
  def change
    add_column :users, :atoken, :string
    add_column :users, :asecret, :string
  end
end
