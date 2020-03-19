class CreateApplications < ActiveRecord::Migration[6.0]
  def change
    create_enum 'application_type', %w[invite application]

    create_table :applications do |t|
      t.enum :type, as: :application_type, null: false

      t.references :user, foreign_key: true
      t.references :project, foreign_key: true
      t.timestamps
    end
  end
end
