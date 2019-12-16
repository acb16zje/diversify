class RemoveDateSubscribedFromNewsletterSubscriptions < ActiveRecord::Migration[6.0]
  def change
    remove_column :newsletter_subscriptions, :date_subscribed
  end
end
