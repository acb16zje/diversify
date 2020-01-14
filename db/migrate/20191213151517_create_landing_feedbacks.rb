# frozen_string_literal: true

class CreateLandingFeedbacks < ActiveRecord::Migration[6.0]
  def change
    create_table :landing_feedbacks do |t|
      t.string :smiley,    null: false, default: ''
      t.string :channel,   null: false, default: ''
      t.boolean :interest, default: true

      t.timestamps
    end
  end
end
