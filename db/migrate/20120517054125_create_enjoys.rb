class CreateEnjoys < ActiveRecord::Migration
  def change
    create_table :enjoys do |t|
      t.string :name
      t.integer :stype

      t.timestamps
    end
  end
end
