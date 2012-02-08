class CreateRnotes < ActiveRecord::Migration
  def change
    create_table :rnotes do |t|
      t.string :body
      t.references :user
      t.references :note

      t.timestamps
    end
    add_index :rnotes, :user_id
    add_index :rnotes, :note_id
  end
end
