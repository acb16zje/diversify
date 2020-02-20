# frozen_string_literal: true

class CreatePersonalities < ActiveRecord::Migration[6.0]
  def change
    # create_enum 'traits', %w[
    #   ISTJ INFJ INTJ ENFJ
    #   ISTP ESFJ INFP ESFP
    #   ENFP ESTP ESTJ ENTJ
    #   INTP ISFJ ENTP ISFP
    # ]
    create_enum 'minds', %w[i e]
    create_enum 'energies', %w[n s]
    create_enum 'natures', %w[f t]
    create_enum 'tactics', %w[p j]

    create_table :personalities do |t|
      t.enum :mind, as: :minds
      t.enum :energy, as: :energies
      t.enum :nature, as: :natures
      t.enum :tactic, as: :tactics

      t.timestamps
    end
  end
end
