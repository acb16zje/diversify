# frozen_string_literal: true

class CreateTaskSkills < ActiveRecord::Migration[6.0]
  def change
    create_table :task_skills do |t|
      t.references :task, foreign_key: true, null: false
      t.references :skill, foreign_key: true, null: false

      t.timestamps
    end

    add_index :task_skills, %i[skill_id task_id], unique: true
  end
end
