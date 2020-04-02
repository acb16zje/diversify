# frozen_string_literal: true

class CreateNewsletterFeedbacks < ActiveRecord::Migration[6.0]
  def change
    create_table :newsletter_feedbacks do |t|
      t.string :email,   null: false, default: ''
      t.string :reason,  null: false, default: ''

      t.references :newsletter_subscription, foreign_key: true, null: false

      t.timestamps
    end
  end
end
