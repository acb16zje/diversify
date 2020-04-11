# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.datetime :opened_at
      t.string :key, default: ''

      t.references :user, foreign_key: true, null: false
      t.references :notifier, polymorphic: true, index: true
      t.references :notifiable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
