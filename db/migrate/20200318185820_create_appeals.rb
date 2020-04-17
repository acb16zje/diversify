# frozen_string_literal: true

class CreateAppeals < ActiveRecord::Migration[6.0]
  def change
    create_enum 'appeal_type', %w[invitation application]

    create_table :appeals do |t|
      t.enum :type, as: :appeal_type, default: 'invitation', null: false

      t.references :user, foreign_key: true, null: false
      t.references :project, foreign_key: true, null: false
      t.timestamps
    end

    add_index :appeals, %i[user_id project_id], unique: true
  end
end
