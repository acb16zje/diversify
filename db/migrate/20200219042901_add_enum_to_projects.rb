class AddEnumToProjects < ActiveRecord::Migration[6.0]
  def change
    reversible do |dir|
      change_table :projects do |t|
        dir.up do
          create_enum 'status_name', %w[Open Active Completed]
          t.remove :status
          t.enum :status, as: :status_name, default: 'Active', null: false
          t.remove :visibility
          t.boolean :visibility, default: true
        end

        dir.down do
          drop_enum 'status_name'
          t.remove :status
          t.remove :visibility
        end
      end
    end
  end
end
