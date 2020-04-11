# frozen_string_literal: true

# == Schema Information
#
# Table name: collaborations
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  team_id    :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_collaborations_on_team_id              (team_id)
#  index_collaborations_on_user_id              (user_id)
#  index_collaborations_on_user_id_and_team_id  (user_id,team_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (team_id => teams.id)
#  fk_rails_...  (user_id => users.id)
#

class Collaboration < ApplicationRecord
  belongs_to :user
  belongs_to :team

  validates :user_id, presence: true, uniqueness: { scope: :team_id }
  validates :team_id, presence: true
end
