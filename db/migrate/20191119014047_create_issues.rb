# frozen_string_literal: true

class CreateIssues < ActiveRecord::Migration[6.0]
  def change
    create_table :issues do |t|
      t.string :name,      null: false
      t.text :description, null: false
      t.string :status,    null: false

      t.references :project, foreign_key: true, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
