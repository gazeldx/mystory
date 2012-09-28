class CreateRhobbies < ActiveRecord::Migration
  def change
    create_table :rhobbies do |t|
      t.references :user
      t.references :hobby

      t.timestamps
    end
    add_index :rhobbies, :user_id
    add_index :rhobbies, :hobby_id
  end
end
