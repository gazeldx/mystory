class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :title
      t.text :content
      t.references :category
      t.references :user
      t.timestamps
    end
  end
end
