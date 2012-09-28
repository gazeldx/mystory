class CreateTracemaps < ActiveRecord::Migration
  def change
    create_table :tracemaps do |t|
      t.string :siteid
      t.string :sitename
      t.references :blog

      t.timestamps
    end
    add_index :tracemaps, :siteid
    add_index :tracemaps, :blog_id
  end
end
