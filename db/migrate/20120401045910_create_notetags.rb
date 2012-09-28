class CreateNotetags < ActiveRecord::Migration
  def change
    create_table :notetags do |t|
      t.string :name
      t.references :note
    end
    add_index :notetags, :note_id
    add_index :notetags, :name
  end
end
