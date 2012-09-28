class AddQqOpenidTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :openid, :string
    add_column :users, :token, :string
  end
end
