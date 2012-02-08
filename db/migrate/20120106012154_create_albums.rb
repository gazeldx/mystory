class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :name
      t.string :description
      t.references :user
      t.references :photo

      t.timestamps
    end
    add_index :albums, :user_id
  end
end
