class CreateApplications < ActiveRecord::Migration[6.0]
  def change
    create_enum 'application_type', %w[Invite Application]

    create_table :applications do |t|
      t.enum :types, as: :application_type, default: 'Invite', null: false

      t.references :user, foreign_key: true, null: false
      t.references :project, foreign_key: true, null: false
      t.timestamps
    end
  end
end
