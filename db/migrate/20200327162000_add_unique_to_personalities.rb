# frozen_string_literal: true

class AddUniqueToPersonalities < ActiveRecord::Migration[6.0]
  def change
    add_index :personalities, %i[mind energy nature tactic], unique: true
  end
end
