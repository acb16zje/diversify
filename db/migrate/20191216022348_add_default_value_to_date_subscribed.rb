class AddDefaultValueToDateSubscribed < ActiveRecord::Migration[6.0]
  def change
    change_column_default :newsletter_subscriptions, :date_subscribed, Time.now
  end
end
