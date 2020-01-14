# frozen_string_literal: true

class CreateLicenses < ActiveRecord::Migration[6.0]
  def change
    create_table :licenses do |t|
      t.date :start_date, null: false

      t.references :user, foreign_key: true
      t.references :subscription_plan, foreign_key: true

      t.timestamps
    end
  end
end
