# frozen_string_literal: true

class AddCompabilityToPersonality < ActiveRecord::Migration[6.0]
  def change
    add_column :personalities, :compabilities, :integer, array: true, default: []
  end
end
