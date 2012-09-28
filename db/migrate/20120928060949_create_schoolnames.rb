class CreateSchoolnames < ActiveRecord::Migration
  def change
    create_table :schoolnames do |t|
      t.string :name, :null => false
      t.references :group, :null => false
      t.timestamps
    end
  end
end
