class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :name
      t.string :passwd
      t.string :email
      t.string :domain
      t.string :memo
      t.string :maxim
      t.string :avatar
      t.string :city
      t.integer :birthday
      t.string :jobs
      t.string :company
      t.string :school
      t.timestamps
    end
  end
end
