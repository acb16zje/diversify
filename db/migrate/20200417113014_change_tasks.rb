# frozen_string_literal: true

class ChangeTasks < ActiveRecord::Migration[6.0]
  def change
    create_enum 'priority', %w[high medium low]

    change_table :tasks, bulk: true do |t|
      t.enum :priority, as: :priority, default: 'medium', null: false
      t.references :users, foreign_key: true
      t.integer :percentage, null: false, default: 0
    end
  end
end
