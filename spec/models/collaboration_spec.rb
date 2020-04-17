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

require 'rails_helper'

describe Collaboration, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:team) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:team_id) }

    describe 'UNIQUE user_id, team_id' do
      subject { build(:collaboration) }

      it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:team_id) }
    end
  end
end
