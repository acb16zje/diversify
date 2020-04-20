# frozen_string_literal: true

require 'rails_helper'

describe UserPolicy, type: :policy do
  let(:user) { build_stubbed(:user) }
  let(:record) { build_stubbed(:user) }

  let(:context) { { user: user } }

  describe 'relation_scope(:assignee)' do
    subject do
      policy.apply_scope(
        target,
        type: :active_record_relation,
        scope_options: params,
        name: :assignee
      )
    end

    let(:project) { create(:project) }
    let(:team) { create(:team, project: project) }
    let(:target) { User.where(name: %w[Owner Test Test2]) }
    let(:params) { { team_id: team.id, project: project } }

    before do
      project.unassigned_team.users << create(:user, name: 'Test')
      team.users << create(:user, name: 'Test2')
    end

    context 'when is assigned to team' do
      it { is_expected.to include(include('Test2')) }
    end

    context 'when is  owner' do
      before { project.user = user }

      it { is_expected.to include(include('Test2'), include('Test')) }
    end

    context 'when is admin' do
      before { user.admin = true }

      it { is_expected.to include(include('Test2'), include('Test')) }
    end
  end
end
