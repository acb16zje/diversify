class CreateNewletterSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :newletter_subscriptions do |t|
      t.string :email,            null: false
      t.date :date_subscribed,    null: false

      t.timestamps
    end
  end
end
