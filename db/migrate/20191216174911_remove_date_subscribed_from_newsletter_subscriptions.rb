# frozen_string_literal: true

class RemoveDateSubscribedFromNewsletterSubscriptions < ActiveRecord::Migration[6.0]
  def change
    # rubocop:todo Rails/ReversibleMigration
    remove_column :newsletter_subscriptions, :date_subscribed
    # rubocop:enable Rails/ReversibleMigration
  end
end
