# frozen_string_literal: true

class UserSkills < ActiveRecord::Migration[6.0]
  def change
    create_table :user_skills do |t|
      t.references :user, foreign_key: true, null: false
      t.references :skill, foreign_key: true, null: false

      t.timestamps default: -> { 'CURRENT_TIMESTAMP' }
    end

    add_index :user_skills, %i[skill_id user_id], unique: true
  end
end
