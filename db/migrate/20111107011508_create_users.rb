class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :name
      t.string :passwd
      t.string :email
      t.string :domain

      t.timestamps
    end
  end
end
