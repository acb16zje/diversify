# frozen_string_literal: true

# == Schema Information
#
# Table name: teams
#
#  id         :bigint           not null, primary key
#  name       :string           default(""), not null
#  team_size  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :bigint           not null
#
# Indexes
#
#  index_teams_on_name_and_project_id  (name,project_id) UNIQUE
#  index_teams_on_project_id           (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#

require 'rails_helper'

describe Team, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:project) }
    it { is_expected.to have_many(:users) }
    it { is_expected.to have_many(:skills) }
  end

  describe 'validations' do
    let(:team) { build(:team) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:team_size) }
    it { is_expected.to validate_numericality_of(:team_size) }

    context 'when validate unique team name' do
      it do
        expect(team).to validate_uniqueness_of(:name)
          .scoped_to(:project_id).with_message('already exist')
      end
    end

    context 'when validate member count within team size' do
      let(:user) { build(:user) }

      before do
        team.team_size = 0
        team.users << user
        team.save
      end

      it do
        expect(team.errors.full_messages).to include(
          'Team Size is smaller than total members'
        )
      end
    end
  end
end
