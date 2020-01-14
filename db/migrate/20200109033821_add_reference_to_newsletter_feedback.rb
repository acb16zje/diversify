# frozen_string_literal: true

class AddReferenceToNewsletterFeedback < ActiveRecord::Migration[6.0]
  def change
    add_reference :newsletter_feedbacks, :newsletter_subscription, foreign_key: true
    # rubocop:todo Rails/ReversibleMigration
    remove_column :newsletter_feedbacks, :email
    # rubocop:enable Rails/ReversibleMigration
  end
end
