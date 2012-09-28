class CreatePhotocomments < ActiveRecord::Migration
  def change
    create_table :photocomments do |t|
      t.text :body
      t.references :photo
      t.references :user

      t.timestamps
    end
    add_index :photocomments, :photo_id
    add_index :photocomments, :user_id
  end
end
