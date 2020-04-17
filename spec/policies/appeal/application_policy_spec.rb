# frozen_string_literal: true

require 'rails_helper'

describe Appeal::ApplicationPolicy, type: :policy do
  let(:user) { build_stubbed(:user) }
  let(:record) { build_stubbed(:appeal) }

  let(:context) { { user: user } }

  describe_rule :create? do
    failed 'when project is active' do
      before { record.project.status = 'active' }
    end

    failed 'when project is completed' do
      before { record.project.status = 'completed' }
    end

    failed 'when project is not public' do
      before { record.project.visibility = false }
    end

    failed 'when user is project owner' do
      before { record.project.user = user }
    end

    succeed 'when project is open, public, and user is not project owner' do
      before do
        record.project.status = 'open'
        record.project.visibility = true
      end
    end
  end

  describe_rule :accept? do
    failed 'when user is application owner' do
      before { record.user = user }
    end

    succeed 'when user is project owner and not application owner' do
      before { record.project.user = user }
    end

    succeed 'when user is admin' do
      before { user.admin = true }
    end
  end
end
