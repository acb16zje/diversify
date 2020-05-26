# frozen_string_literal: true

require 'rails_helper'

describe TaskBlueprint, type: :serializer do
  subject { described_class.render_as_hash(task) }

  let(:task) { build_stubbed(:task) }

  describe 'fields' do
    it { is_expected.to include(id: task.id) }
    it { is_expected.to include(description: task.description) }
    it { is_expected.to include(name: task.name) }
    it { is_expected.to include(percentage: task.percentage) }
    it { is_expected.to include(priority: task.priority) }
    it { is_expected.to include(owner_id: task.user.id) }
    it { is_expected.to include(owner_name: task.user.name) }

    context 'without skill' do
      it { is_expected.to include(skills: []) }
    end

    context 'with skill' do
      let(:task) { create(:task) }

      before { create(:task_skill, task: task) }

      it { is_expected.to include(skills: task.skills.pluck(:name)) }
    end
  end

  describe 'associations' do
    context 'without assignees' do
      it { is_expected.to include(assignees: []) }
    end

    context 'with assignees' do
      let(:task) { create(:task) }
      let!(:task_user) { create(:task_user, task: task) }

      it {
        is_expected.to include(assignees: [UserBlueprint.render_as_hash(task_user.user, view: :assignee)])
      }
    end
  end
end
