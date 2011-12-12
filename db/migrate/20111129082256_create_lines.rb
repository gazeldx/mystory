class CreateLines < ActiveRecord::Migration
  def change
    create_table :lines do |t|
      t.string :title
      t.string :content1
      t.string :url1
      t.string :content2
      t.string :url2
      t.string :content3
      t.string :url3
      t.references :user

      t.timestamps
    end
    add_index :lines, :user_id
  end
end
