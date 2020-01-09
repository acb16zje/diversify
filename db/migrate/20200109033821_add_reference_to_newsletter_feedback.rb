class AddReferenceToNewsletterFeedback < ActiveRecord::Migration[6.0]
  def change
    add_reference :newsletter_feedbacks, :newsletter_subscription, foreign_key: true
    remove_column :newsletter_feedbacks, :email
  end
end
