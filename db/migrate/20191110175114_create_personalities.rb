class CreatePersonalities < ActiveRecord::Migration[6.0]
  def change
    create_table :personalities do |t|
      t.string :trait, null: false, default: ""

      t.timestamps
    end
      add_reference :personalities, :compatible, references: :personalities, index: true
      add_reference :personalities, :incompatible, references: :personalities, index: true
  end
end
