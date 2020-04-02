class AddUniqueToPersonalities < ActiveRecord::Migration[6.0]
  def change
    add_index :personalities, [:mind, :energy, :nature, :tactic], unique: true
  end
end
