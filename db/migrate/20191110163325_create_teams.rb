class CreateTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :teams do |t|
      t.string :name,       null: false, default: "" 
      t.integer :team_size, null: false

      t.timestamps
    end
    add_reference :teams, :project, foreign_key: true, index: true
  end
end
