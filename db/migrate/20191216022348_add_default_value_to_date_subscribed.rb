# frozen_string_literal: true

class AddDefaultValueToDateSubscribed < ActiveRecord::Migration[6.0]
  def change
    # rubocop:todo Rails/ReversibleMigration
    change_column_default :newsletter_subscriptions, :date_subscribed, Time.zone.now
    # rubocop:enable Rails/ReversibleMigration
  end
end
