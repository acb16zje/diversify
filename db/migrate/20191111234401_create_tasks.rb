# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :name,         null: false, default: ''
      t.text :description,    null: false, default: ''
      t.integer :experience,  null: false, default: 0

      t.references :skills, foreign_key: true
      t.references :user, foreign_key: true
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
