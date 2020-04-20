# frozen_string_literal: true

# == Schema Information
#
# Table name: task_skills
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  skill_id   :bigint           not null
#  task_id    :bigint           not null
#
# Indexes
#
#  index_task_skills_on_skill_id              (skill_id)
#  index_task_skills_on_skill_id_and_task_id  (skill_id,task_id) UNIQUE
#  index_task_skills_on_task_id               (task_id)
#
# Foreign Keys
#
#  fk_rails_...  (skill_id => skills.id)
#  fk_rails_...  (task_id => tasks.id)
#
require 'rails_helper'

describe TaskSkill, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:task) }
    it { is_expected.to belong_to(:skill) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:task_id) }
    it { is_expected.to validate_presence_of(:skill_id) }

    describe 'UNIQUE task_id, skill_id' do
      subject { build(:task_skill) }

      it do
        is_expected.to validate_uniqueness_of(:skill_id).scoped_to(:task_id)
      end
    end
  end
end
