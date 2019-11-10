class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.integer :rating,  null: false

      t.timestamps
    end
    add_reference :reviews, :interviewee, references: :user, index: true
    add_reference :reviews, :interviewer, references: :user, index: true
    add_reference :reviews, :project, foreign_key: true, index: true
  end
end
