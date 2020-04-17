# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.string :key, default: ''
      t.boolean :read, default: false, null: false

      t.references :user, foreign_key: true, null: false
      t.references :notifier, polymorphic: true, null: false
      t.references :notifiable, polymorphic: true, null: false
      t.timestamps
    end
  end
end
