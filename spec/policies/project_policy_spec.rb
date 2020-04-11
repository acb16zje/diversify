# frozen_string_literal: true

require 'rails_helper'

describe ProjectPolicy, type: :policy do
  let(:user) { build_stubbed(:user) }
  let(:record) { build_stubbed(:project) }

  let(:context) { { user: user } }

  describe 'relation_scope(:own)' do
    subject do
      policy.apply_scope(target, type: :active_record_relation, name: :own)
            .pluck(:name)
    end

    let(:user) { create(:user) }
    let(:target) { Project.where(name: %w[Test Test2]) }

    before do
      create(:project, name: 'Test', visibility: false, user: user)
      create(:project, name: 'Test2', visibility: false)
    end

    it { is_expected.to eq(%w[Test]) }
  end

  describe 'relation_scope(:joined)' do
    subject do
      policy.apply_scope(target, type: :active_record_relation, name: :joined)
            .pluck(:name)
    end

    let(:user) { create(:user) }
    let(:target) { Project.where(name: %w[Test Test2]) }

    before do
      project = create(:project, name: 'Test', visibility: false)
      project.teams.first.users << user
      create(:project, name: 'Test2', visibility: false)
    end

    it { is_expected.to eq(%w[Test]) }
  end

  describe 'relation_scope(:explore)' do
    subject do
      policy.apply_scope(target, type: :active_record_relation, name: :explore)
            .pluck(:name)
    end

    let(:target) { Project.where(name: %w[Test Test2]) }

    before do
      # Both belongs to another user
      create(:project, name: 'Test')
      create(:project, name: 'Test2', visibility: false)
    end

    context 'when as user' do
      it { is_expected.to eq(%w[Test]) }
    end

    context 'when as admin' do
      before { user.admin = true }

      it { is_expected.to eq(%w[Test Test2]) }
    end
  end

  describe_rule :show? do
    succeed 'when project is public'

    failed 'when project is not public' do
      before { record.visibility = false }

      succeed 'when user is owner' do
        before { record.user = user }
      end

      succeed 'when user is admin' do
        before { user.admin = true }
      end

      succeed 'when user is in team' do
        let(:user) { create(:user) }
        let(:record) { create(:project) }

        before { record.teams.find_by(name: 'Unassigned').users << user }
      end
    end
  end

  describe_rule :manage? do
    succeed 'when user is owner' do
      before { record.user = user }
    end

    succeed 'when user is admin' do
      before { user.admin = true }
    end

    failed 'when user is not owner or admin'
  end

  describe_rule :count? do
    failed 'when not user is not member'

    succeed 'when user is member' do
      let(:user) { create(:user) }
      let(:record) { create(:project) }

      before { record.teams.first.users << user }
    end

    succeed 'when user is owner' do
      before { record.user = user }
    end

    succeed 'when user is admin' do
      before { user.admin = true }
    end
  end

  describe_rule :data? do
    failed 'when user is not management'

    succeed 'when user is owner' do
      before { record.user = user }
    end

    succeed 'when user is admin' do
      before { user.admin = true }
    end
  end
end
