class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.string :domain
      t.string :memo
      t.string :maxim
      t.string :avatar
      t.integer :member_count, :default => 0
      t.integer :stype
      t.references :board
      t.timestamps
    end
  end
end