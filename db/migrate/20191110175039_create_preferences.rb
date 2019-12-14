class CreatePreferences < ActiveRecord::Migration[6.0]
  def change
    create_table :preferences do |t|
      t.integer :group_size,      null: false, default: 0
      t.text    :preferred_tasks, null: false, default: ""

      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
