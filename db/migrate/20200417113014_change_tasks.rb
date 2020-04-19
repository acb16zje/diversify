class ChangeTasks < ActiveRecord::Migration[6.0]
  def change
    change_table :tasks, bulk: true do |t|
      t.references :users, foreign_key: true
      t.integer :percentage, null: false, default: 0
    end
  end
end
