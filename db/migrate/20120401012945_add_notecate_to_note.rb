class AddNotecateToNote < ActiveRecord::Migration
  def change
    change_table :notes do |t|
      t.references :notecate
    end
    add_index :notes, :notecate_id
  end
end
