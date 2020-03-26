class CreateJoinTableUsersTeams < ActiveRecord::Migration[6.0]
  def change
    create_join_table :users, :teams do |t|
      t.index :user_id
      t.index :team_id
    end
  end
end
