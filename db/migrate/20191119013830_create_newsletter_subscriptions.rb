class CreateNewsletterSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :newsletter_subscriptions do |t|
      t.string :email,            null: false
      t.date :date_subscribed,    null: false

      t.index :email, unique: true

      t.timestamps
    end
  end
end
