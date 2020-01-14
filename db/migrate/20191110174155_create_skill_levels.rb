# frozen_string_literal: true

class CreateSkillLevels < ActiveRecord::Migration[6.0]
  def change
    create_table :skill_levels do |t|
      t.integer :experience,   null: false, default: 0
      t.integer :level,        null: false, default: 0

      t.references :user, foreign_key: true
      t.references :skill, foreign_key: true

      t.timestamps
    end
  end
end
