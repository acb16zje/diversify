class ChangeTasks < ActiveRecord::Migration[6.0]
  def change
    change_table :tasks, bulk: true do |t|
      t.remove_references :user
      t.references :users
      t.integer :percentage, null: false, default: 0
    end
  end
end
