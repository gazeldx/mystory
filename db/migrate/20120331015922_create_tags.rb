class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.references :blog
    end
    add_index :tags, :blog_id
    add_index :tags, :name
  end
end
