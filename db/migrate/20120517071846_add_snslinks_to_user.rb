class AddSnslinksToUser < ActiveRecord::Migration
  def change
    add_column :users, :snslinks, :string
  end
end
