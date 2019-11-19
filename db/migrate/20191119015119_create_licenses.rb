class CreateLicenses < ActiveRecord::Migration[6.0]
  def change
    create_table :licenses do |t|
      t.date :start_date,    null:false
      t.timestamps
    end
    add_reference :licenses, :user, foreign_key: true, index: true
    add_reference :licenses, :subscription, foreign_key: true, index: true
    
    remove_column :subscriptions, :start_date , :date
    remove_reference :subscriptions, :user, index: true
  end
end
