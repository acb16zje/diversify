class CreateUserPersonalities < ActiveRecord::Migration[6.0]
  def change
    create_table :user_personalities do |t|
      t.references :user, foreign_key: true
      t.references :personality, foreign_key: true

      t.timestamps
    end
  end
end
