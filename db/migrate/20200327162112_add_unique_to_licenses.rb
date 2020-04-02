class AddUniqueToLicenses < ActiveRecord::Migration[6.0]
  def change
    remove_index :licenses, :user_id
    add_index :licenses, :user_id, unique: true
  end
end
