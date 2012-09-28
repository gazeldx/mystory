class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :description
      t.string :avatar
      t.references :album

      t.timestamps
    end
    add_index :photos, :album_id
  end
end
