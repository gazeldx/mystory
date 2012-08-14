class AddIsdraftToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :is_draft, :boolean, :default => false
  end
end
