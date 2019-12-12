class AddIndexToNewsletterSubscription < ActiveRecord::Migration[6.0]
  def change
    add_index :newsletter_subscriptions, :email, unique: true
  end
end
