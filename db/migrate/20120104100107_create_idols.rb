class CreateIdols < ActiveRecord::Migration
  def change
    create_table :idols do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
