# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id          :bigint           not null, primary key
#  description :text             default(""), not null
#  name        :string           default(""), not null
#  percentage  :integer          default(0), not null
#  priority    :enum             default("Medium"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  project_id  :bigint
#  skills_id   :bigint
#  user_id     :bigint
#  users_id    :bigint
#
# Indexes
#
#  index_tasks_on_project_id  (project_id)
#  index_tasks_on_skills_id   (skills_id)
#  index_tasks_on_user_id     (user_id)
#  index_tasks_on_users_id    (users_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#  fk_rails_...  (skills_id => skills.id)
#  fk_rails_...  (user_id => users.id)
#  fk_rails_...  (users_id => users.id)
#
require 'rails_helper'

describe Task, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:project) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:users) }
    it { is_expected.to have_many(:skills) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:priority) }
    it { is_expected.to validate_presence_of(:percentage) }
    it { is_expected.to validate_numericality_of(:percentage) }

    describe '#check_in_project' do
      subject { task.errors.full_messages }

      let(:task) { build(:task) }

      before { task.users << build(:user) }

      it { is_expected.to include('User is not in project') }
    end
  end

  describe 'scopes' do
    describe ':user_data' do
      let(:task) { create(:task) }
      let(:user) { create(:user) }

      before { task.users << user }

      it do
        expect(described_class.user_data.map(&:attributes)).to eql(
          [{ "id": task.id, "user_id": user.id,
             "user_name": user.name }.stringify_keys]
        )
      end
    end

    describe ':data' do
      let(:user) { create(:user) }
      let(:task) { create(:task, user: user) }
      let(:skill) { create(:skill) }
      let(:result) do
        { "id": task.id, "description": task.description, "name": task.name,
          "percentage": task.percentage, "priority": task.priority,
          "user_id": task.user_id, "owner_name": user.name,
          "skill_names": skill.name }.stringify_keys
      end

      before { task.skills << skill }

      it do
        expect(described_class.data.map(&:attributes)).to eql([result])
      end
    end
  end
end
