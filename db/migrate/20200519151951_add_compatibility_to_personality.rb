# frozen_string_literal: true

class AddCompatibilityToPersonality < ActiveRecord::Migration[6.0]
  def change
    add_column :personalities, :compatibilities, :integer, array: true, default: []
  end
end
