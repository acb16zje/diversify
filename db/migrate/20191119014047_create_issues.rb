class CreateIssues < ActiveRecord::Migration[6.0]
  def change
    create_table :issues do |t|
      t.string :name,      null: false
      t.text :description, null: false
      t.string :status,    null: false
      t.timestamps
    end
    add_reference :issues, :project, foreign_key: true, index: true
    add_reference :issues, :user, foreign_key: true, index: true
  end
end
