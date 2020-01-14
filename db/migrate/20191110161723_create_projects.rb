# frozen_string_literal: true

class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.string :name,        null: false, default: ''
      t.text :description,   null: false, default: ''
      t.string :status,      null: false, default: 'active'
      t.string :visibility,  null: false, default: 'public'

      t.references :category, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
