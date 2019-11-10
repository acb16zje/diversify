class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string :name,        null: false, default: ""
      t.text :description,   null: false, default: ""
      t.string :status,      null: false, default: "active"
      t.string :visibility,  null: false, default: "public"

      t.timestamps
    end
    add_reference :projects, :category, foreign_key: true, index: true
    add_reference :projects, :user, foreign_key: true, index: true
  end
end
