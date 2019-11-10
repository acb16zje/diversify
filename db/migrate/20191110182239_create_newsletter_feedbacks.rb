class CreateNewsletterFeedbacks < ActiveRecord::Migration[6.0]
  def change
    create_table :newsletter_feedbacks do |t|
      t.string :email,   null:false, default: ""
      t.string :reason,  null:false, default: ""
      
      t.timestamps
    end
  end
end
