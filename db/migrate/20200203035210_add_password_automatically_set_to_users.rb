# frozen_string_literal: true

class AddPasswordAutomaticallySetToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :password_automatically_set, :boolean, null: false, default: false
  end
end
