class CreatePersonalities < ActiveRecord::Migration[6.0]
  def change
    create_table :personalities do |t|
      t.string :trait, null: false, default: ""

      t.timestamps
    end
  end
end
