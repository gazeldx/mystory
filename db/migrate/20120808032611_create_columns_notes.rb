class CreateColumnsNotes < ActiveRecord::Migration
  def change
    create_table :columns_notes, :id => false do |t|
      t.references :column
      t.references :note

      t.timestamps
    end
    add_index :columns_notes, :column_id
    add_index :columns_notes, :note_id
  end
end