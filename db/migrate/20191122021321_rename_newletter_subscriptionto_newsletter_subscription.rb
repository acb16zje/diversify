class RenameNewletterSubscriptiontoNewsletterSubscription < ActiveRecord::Migration[6.0]
  def change
    rename_table :newletter_subscriptions, :newsletter_subscriptions
  end
end
