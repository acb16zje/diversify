# frozen_string_literal: true

require 'rails_helper'

describe TeamPolicy, type: :policy do
  let(:user) { build_stubbed :user }
  let(:record) { create(:team) }

  let(:context) { { user: user } }

  describe_rule :show? do
    succeed 'when project is public'

    failed 'when project is private' do
      before { record.project.visibility = false }

      succeed 'when user is admin' do
        before { user.admin = true }
      end

      succeed 'when user is project owner' do
        before { record.project.user = user }
      end
    end
  end

  describe_rule :access_team? do
    succeed 'when user is admin' do
      before { user.admin = true }
    end

    succeed 'when user is project owner' do
      before { record.project.user = user }
    end

    failed 'when user is not authorized to manage'

    failed 'when team is default Unassigned team' do
      before { record.name = 'Unassigned' }
    end
  end

  describe_rule :manage? do
    failed 'when user is not authorized to manage'

    succeed 'when user is admin' do
      before { user.admin = true }
    end

    succeed 'when user is project owner' do
      before { record.project.user = user }
    end
  end
end
