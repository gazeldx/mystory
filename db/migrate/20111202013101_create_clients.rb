class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :loginname
      t.string :name
      t.string :passwd
      t.string :email

      t.timestamps
    end
  end
end
