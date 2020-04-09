# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_enum 'status_name', %w[open active completed]

    create_table :projects do |t|
      t.string :name,        null: false, default: '', limit: 100
      t.text :description,   null: false, default: ''
      t.boolean :visibility, null: false, default: true

      t.enum :status, as: :status_name, default: 'active', null: false

      t.references :category, foreign_key: true
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
