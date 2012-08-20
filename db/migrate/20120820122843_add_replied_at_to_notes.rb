class AddRepliedAtToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :replied_at, :timestamp
  end
end
