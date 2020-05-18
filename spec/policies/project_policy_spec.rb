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
      project.unassigned_team.users << user
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

  describe 'relation_scope(:profile_owned)' do
    subject do
      policy.apply_scope(target, type: :active_record_relation,
                                 name: :profile_owned,
                                 scope_options: { target: user2 })
            .pluck(:name)
    end

    let(:user2) { create(:user) }
    let(:target) { Project.where(name: %w[Test Test2 Test3]) }

    before do
      create(:project, name: 'Test', visibility: false, user: user2)
      create(:project, name: 'Test3', visibility: true, user: user2)
    end

    context 'when is owner' do
      let(:context) { { user: user2 } }

      it { is_expected.to eq(%w[Test Test3]) }
    end

    context 'when is admin' do
      before { user.admin = true }

      it { is_expected.to eq(%w[Test Test3]) }
    end

    context 'when is not owner' do
      it { is_expected.to eq(%w[Test3]) }
    end

    context 'when is in private project' do
      let(:user) { create(:user) }

      before do
        project = create(:project, name: 'Test2', visibility: false, user: user2)
        project.unassigned_team.users << user
      end

      it { is_expected.to eq(%w[Test2 Test3]) }
    end
  end

  describe 'relation_scope(:profile_joined)' do
    subject do
      policy.apply_scope(target, type: :active_record_relation,
                                 name: :profile_joined,
                                 scope_options: { target: user2 })
            .pluck(:name)
    end

    let(:admin) { create(:admin) }
    let(:user2) { create(:user) }
    let(:target) { Project.where(name: %w[Test Test2 Test3]) }

    before do
      project = create(:project, name: 'Test', visibility: false, user: admin)
      project.unassigned_team.users << user2
      project = create(:project, name: 'Test3', visibility: true, user: admin)
      project.unassigned_team.users << user2
    end

    context 'when is owner' do
      let(:context) { { user: user2 } }

      it { is_expected.to eq(%w[Test Test3]) }
    end

    context 'when is admin' do
      before { user.admin = true }

      it { is_expected.to eq(%w[Test Test3]) }
    end

    context 'when is not owner' do
      it { is_expected.to eq(%w[Test3]) }
    end

    context 'when is in private project' do
      let(:user) { create(:user) }

      before do
        project = create(:project, name: 'Test2', visibility: false, user: admin)
        project.unassigned_team.users << user
        project.unassigned_team.users << user2
      end

      it { is_expected.to eq(%w[Test2 Test3]) }
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

        before { record.unassigned_team.users << user }
      end

      succeed 'when user is invited' do
        let(:user) { create(:user) }
        let(:record) { create(:project) }
        let(:invitation) { create(:invitation, user: user) }

        before { record.appeals << invitation }
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

  describe_rule :change_visibility? do
    let(:user) { create(:user) }

    failed 'when not user has free license'

    succeed 'when user has premium license' do
      before { user.license.plan = 'pro' }
    end

    succeed 'when user is admin' do
      before { user.admin = true }
    end
  end

  describe_rule :create_task? do
    let(:record) { create(:project) }
    let(:user) { create(:user) }

    succeed 'when user in team' do
      before do
        team = create(:team, project: record)
        team.users << user
      end
    end

    succeed 'when user is owner' do
      before { record.user = user }
    end

    succeed 'when user is admin' do
      before { user.admin = true }
    end

    failed 'when user cannot manage or not in team'
  end
end
