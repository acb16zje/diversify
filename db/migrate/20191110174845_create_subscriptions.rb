class CreateSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :subscriptions do |t|
      t.string :subscription,  null: false
      t.float :monthly_cost,   null: false     
      t.date :start_date,      null: false
      t.timestamps
    end
    add_reference :subscriptions, :user, foreign_key: true, index: true
  end
end
