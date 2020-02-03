class AddUniqueToIdentities < ActiveRecord::Migration[6.0]
  def change
    add_index :identities, %i[provider uid], unique: true
    add_index :identities, %i[provider user_id], unique: true
  end
end
