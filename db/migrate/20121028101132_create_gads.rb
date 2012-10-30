class CreateGads < ActiveRecord::Migration
  def change
    create_table :gads do |t|
      t.string :avatar
      t.integer :stype
      t.string :url
      t.references :group

      t.timestamps
    end
    add_index :gads, :group_id
  end
end
