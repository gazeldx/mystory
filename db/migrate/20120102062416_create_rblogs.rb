class CreateRblogs < ActiveRecord::Migration
  def change
    create_table :rblogs do |t|
      t.string :body
      t.references :user
      t.references :blog

      t.timestamps
    end
    add_index :rblogs, :user_id
    add_index :rblogs, :blog_id
  end
end
