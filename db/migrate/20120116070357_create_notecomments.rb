class CreateNotecomments < ActiveRecord::Migration
  def change
    create_table :notecomments do |t|
      t.text :body
      t.references :note
      t.references :user

      t.timestamps
    end
    add_index :notecomments, :note_id
    add_index :notecomments, :user_id
  end
end
