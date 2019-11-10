class CreateSkills < ActiveRecord::Migration[6.0]
  def change
    create_table :skills do |t|
      t.string :name,        null: false, default: ""
      t.text :description,   null: false, default: ""
      
      t.timestamps
    end
    add_reference :skills, :category, foreign_key: true, index: true
  end
end
