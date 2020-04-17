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
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:team_size) }
    it { is_expected.to validate_numericality_of(:team_size) }

    describe 'UNIQUE name, project_id' do
      subject { build(:team) }

      it {
        is_expected.to validate_uniqueness_of(:name)
          .scoped_to(:project_id)
          .with_message('already exist')
      }
    end

    describe '#check_users_limit' do
      subject { team.errors.full_messages }

      let(:team) { build(:team, team_size: 1) }

      before { team.users << [build_list(:user, 3)] }

      it { is_expected.to include('Team Size is smaller than total members') }
    end
  end
end
