# frozen_string_literal: true

class CreateCollaborations < ActiveRecord::Migration[6.0]
  def change
    create_table :collaborations do |t|
      t.references :user, foreign_key: true, null: false
      t.references :team, foreign_key: true, null: false

      t.timestamps
    end

    add_index :collaborations, %i[user_id team_id], unique: true
  end
end
