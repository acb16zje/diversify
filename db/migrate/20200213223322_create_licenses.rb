class CreateLicenses < ActiveRecord::Migration[6.0]
  def change
    create_enum 'plan_name', %w[free pro ultimate]

    create_table :licenses do |t|
      t.enum :plan, as: :plan_name, default: 'free', null: false

      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
