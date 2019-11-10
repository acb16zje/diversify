class CreatePreferences < ActiveRecord::Migration[6.0]
  def change
    create_table :preferences do |t|
      t.integer :group_size,      null: false, default: 0
      t.text  :preferred_tasks,   null: false, default: ""

      t.timestamps
    end
      add_reference :preferences, :user, foreign_key: true, index: true
  end
end
