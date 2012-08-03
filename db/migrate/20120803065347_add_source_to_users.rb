class AddSourceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :source, :integer, :default => 0
  end
end
