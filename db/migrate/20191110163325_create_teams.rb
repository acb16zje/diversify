# frozen_string_literal: true

class CreateTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :teams do |t|
      t.string :name,       null: false, default: ''
      t.integer :team_size, null: false

      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
