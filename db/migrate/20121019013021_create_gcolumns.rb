class CreateGcolumns < ActiveRecord::Migration
  def change
    create_table :gcolumns do |t|
      t.string :name
      t.references :group

      t.timestamp :created_at
    end
    add_index :gcolumns, :group_id
  end
end
