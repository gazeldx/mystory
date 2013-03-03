# This migration comes from books (originally 20130227003436)
class CreateBooksBooks < ActiveRecord::Migration
  def change
    create_table :books_books do |t|
      t.string :title
      t.text :summary
      t.text :body
      t.string :writer
      t.string :translator
      t.float :price
      t.string :avatar
      t.references :user
      t.timestamps
    end
  end
end
