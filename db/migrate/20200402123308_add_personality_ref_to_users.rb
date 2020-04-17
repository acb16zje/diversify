# frozen_string_literal: true

class AddPersonalityRefToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :personality, foreign_key: true
  end
end
