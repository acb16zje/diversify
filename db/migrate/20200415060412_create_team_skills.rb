# frozen_string_literal: true

class CreateTeamSkills < ActiveRecord::Migration[6.0]
  def change
    create_table :team_skills do |t|
      t.references :team, foreign_key: true, null: false
      t.references :skill, foreign_key: true, null: false

      t.timestamps
    end

    add_index :team_skills, %i[skill_id team_id], unique: true
  end
end
