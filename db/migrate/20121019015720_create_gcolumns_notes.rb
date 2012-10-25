class CreateGcolumnsNotes < ActiveRecord::Migration
  def change
    create_table :gcolumns_notes, :id => false do |t|
      t.references :gcolumn
      t.references :note

      t.timestamp :created_at
    end
    add_index :gcolumns_notes, :gcolumn_id
    add_index :gcolumns_notes, :note_id
  end
end
