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
      create(:project, name: 'Test', user: user)
      create(:project, name: 'Test2')
    end

    it { is_expected.to eq(%w[Test]) }
  end

  describe 'relation_scope(:joined)' do
    subject do
      policy.apply_scope(target, type: :active_record_relation, name: :joined).pluck(:name)
    end

    let(:user) { create(:user) }
    let(:target) { Project.where(name: %w[Test Test2]) }

    before do
      project = create(:project, name: 'Test')
      project.unassigned_team.users << user
      create(:project, name: 'Test2')
    end

    it { is_expected.to eq(%w[Test]) }
  end

  describe 'relation_scope(:explore)' do
    subject do
      policy.apply_scope(target, type: :active_record_relation, name: :explore).pluck(:name)
    end

    let(:target) { Project.where(name: %w[Test Test2]) }

    before do
      # Both belongs to another user
      create(:project, name: 'Test')
      create(:project, :private, name: 'Test2')
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
      policy.apply_scope(target,
                         type: :active_record_relation,
                         name: :profile_owned,
                         scope_options: { profile_owner: profile_owner })
            .pluck(:name)
    end

    let(:profile_owner) { create(:user, :pro) }
    let(:target) { Project.where(name: %w[Test Test2 Test3]) }

    before do
      create(:project, name: 'Test', user: profile_owner)
      create(:project, :private, name: 'Test2', user: profile_owner)
    end

    context 'when user is profile owner' do
      let(:user) { create(:user, :pro) }
      let(:profile_owner) { user }

      it { is_expected.to eq(%w[Test Test2]) }
    end

    context 'when user is not profile owner' do
      it { is_expected.to eq(%w[Test]) }
    end

    context 'when user is admin' do
      before { user.admin = true }

      it { is_expected.to eq(%w[Test Test2]) }
    end

    context 'when user is in private project of profile owner' do
      let(:user) { create(:user) }

      before do
        project = create(:project, :private, name: 'Test3', user: profile_owner)
        project.unassigned_team.users << user
      end

      it { is_expected.to eq(%w[Test Test3]) }
    end
  end

  describe 'relation_scope(:profile_joined)' do
    subject do
      policy.apply_scope(target, type: :active_record_relation,
                                 name: :profile_joined,
                                 scope_options: { profile_owner: profile_owner })
            .pluck(:name)
    end

    let(:admin) { create(:admin) }
    let(:profile_owner) { create(:user) }
    let(:target) { Project.where(name: %w[Test Test2 Test3]) }

    before do
      project = create(:project, :private, name: 'Test', user: admin)
      project.unassigned_team.users << profile_owner
      project = create(:project, name: 'Test2', user: admin)
      project.unassigned_team.users << profile_owner
    end

    context 'when user is profile owner' do
      let(:context) { { user: profile_owner } }

      it { is_expected.to eq(%w[Test Test2]) }
    end

    context 'when user is not profile owner' do
      it { is_expected.to eq(%w[Test2]) }
    end

    context 'when is admin' do
      before { user.admin = true }

      it { is_expected.to eq(%w[Test Test2]) }
    end

    context 'when is in private project' do
      let(:user) { create(:user) }

      before do
        project = create(:project, :private, name: 'Test3', user: admin)
        project.unassigned_team.users << user
        project.unassigned_team.users << profile_owner
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

  describe_rule :change_status? do
    failed 'when not user is not member'

    succeed 'when user is owner' do
      before { record.user = user }
    end

    succeed 'when user is admin' do
      before { user.admin = true }
    end
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

    failed 'when user is not project owner' do
      failed 'when user has free license'

      failed 'when user has pro license' do
        before { user.license.pro! }
      end

      failed 'when user has ultiamte license' do
        before { user.license.ultimate! }
      end
    end

    context 'when user is project owner' do
      before { record.user = user }

      failed 'when user has free license'

      succeed 'when user has pro license' do
        before { user.license.pro! }
      end

      succeed 'when user has ultiamte license' do
        before { user.license.ultimate! }
      end
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
