# frozen_string_literal: true

class CreateSubscriptionPlans < ActiveRecord::Migration[6.0]
  def change
    create_table :subscription_plans do |t|
      t.string :name,         null: false
      t.float  :monthly_cost, null: false

      t.index :name, unique: true

      t.timestamps
    end
  end
end
