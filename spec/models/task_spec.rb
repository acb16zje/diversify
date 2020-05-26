# frozen_string_literal: true

# == Schema Information
#
# Table name: tasks
#
#  id          :bigint           not null, primary key
#  description :text             default(""), not null
#  name        :string           default(""), not null
#  percentage  :integer          default(0), not null
#  priority    :enum             default("medium"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  project_id  :bigint
#  user_id     :bigint
#
# Indexes
#
#  index_tasks_on_project_id  (project_id)
#  index_tasks_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#  fk_rails_...  (user_id => users.id)
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
end
