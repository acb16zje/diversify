# frozen_string_literal: true

# == Schema Information
#
# Table name: team_skills
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  skill_id   :bigint           not null
#  team_id    :bigint           not null
#
# Indexes
#
#  index_team_skills_on_skill_id              (skill_id)
#  index_team_skills_on_skill_id_and_team_id  (skill_id,team_id) UNIQUE
#  index_team_skills_on_team_id               (team_id)
#
# Foreign Keys
#
#  fk_rails_...  (skill_id => skills.id)
#  fk_rails_...  (team_id => teams.id)
#
require 'rails_helper'

describe TeamSkill, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:team) }
    it { is_expected.to belong_to(:skill) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:skill_id) }
    it { is_expected.to validate_presence_of(:team_id) }

    context 'when validate unique team skill' do
      let(:team_skill) { build(:team_skill) }

      it { expect(team_skill).to validate_uniqueness_of(:skill_id).scoped_to(:team_id) }
    end
  end
end
