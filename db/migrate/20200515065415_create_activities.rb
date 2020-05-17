# frozen_string_literal: true

class CreateActivities < ActiveRecord::Migration[6.0]
  def change
    create_table :activities do |t|
      t.string :key, default: ''

      t.references :user, foreign_key: true, null: false
      t.references :project, foreign_key: true
      t.timestamps
    end
  end
end
