# frozen_string_literal: true

class CreateSkills < ActiveRecord::Migration[6.0]
  def change
    create_table :skills do |t|
      t.string :name, null: false, default: ''
      t.index :name, unique: true
      t.text :description, null: false, default: ''

      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
