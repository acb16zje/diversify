class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :name,         null:false, default: ""
      t.text :description,    null:false, default: ""
      t.integer :experience,  null:false, default: 0

      t.timestamps
    end
    add_reference :tasks, :skills, foreign_key: true, index: true
    add_reference :tasks, :user, foreign_key: true, index: true
    add_reference :tasks, :project, foreign_key: true, index: true
  end
end
