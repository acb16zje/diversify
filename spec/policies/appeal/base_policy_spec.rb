# frozen_string_literal: true

require 'rails_helper'

describe Appeal::BasePolicy, type: :policy do
  let(:user) { build_stubbed(:user) }
  let(:record) { build_stubbed(:appeal) }

  let(:context) { { user: user } }

  describe_rule :index? do
    let(:record) { build_stubbed(:project) }

    failed 'when user is not appeal owner and not admin'

    succeed 'when user is project owner' do
      before { record.user = user }
    end

    succeed 'when user is admin' do
      before { user.admin = true }
    end
  end

  describe_rule :destroy? do
    failed 'when user is not appeal owner, not project owner, and not admin'

    succeed 'when user is appeal owner' do
      before { record.user = user }
    end

    succeed 'when user is project owner' do
      before { record.project.user = user }
    end

    succeed 'when user is admin' do
      before { user.admin = true }
    end
  end

  describe_rule :project_owner? do
    failed 'when user is not owner of appeal.project'

    succeed 'when user is owner of appeal.project' do
      before { record.project.user = user }
    end
  end
end
