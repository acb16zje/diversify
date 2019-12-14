class AddSubscribedToNewsletterSubscription < ActiveRecord::Migration[6.0]
  def change
    add_column :newsletter_subscriptions, :subscribed, :boolean, null: false, default: true
  end
end
