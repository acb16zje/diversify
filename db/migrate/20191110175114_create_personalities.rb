# frozen_string_literal: true

class CreatePersonalities < ActiveRecord::Migration[6.0]
  def change

    create_enum 'minds', %w[I E]
    create_enum 'energies', %w[S N]
    create_enum 'natures', %w[T F]
    create_enum 'tactics', %w[J P]

    create_table :personalities do |t|
      t.enum :mind, as: :minds
      t.enum :energy, as: :energies
      t.enum :nature, as: :natures
      t.enum :tactic, as: :tactics

      t.timestamps
    end
  end
end
