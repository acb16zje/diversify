class CreateSkillLevels < ActiveRecord::Migration[6.0]
  def change
    create_table :skill_levels do |t|
      t.integer :experience,   null: false,default: 0
      t.integer :level,        null: false,default: 0

      t.timestamps
    end
    add_reference :skill_levels, :user, foreign_key: true, index: true
    add_reference :skill_levels, :skill, foreign_key: true, index: true
  end
end
