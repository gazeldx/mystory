class CreatePortions < ActiveRecord::Migration
  def change
    create_table :portions do |t|
      t.string :title
      t.text :content
      t.references :user

      t.timestamps
    end
  end
end
