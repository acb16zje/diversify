# frozen_string_literal: true

require 'rails_helper'

describe InvitePolicy, type: :policy do
  let(:user) { build_stubbed :user }
  let(:record) { create(:invite) }
  # let(:application) {build_stubbed :application }

  let(:context) { { user: user } }

  describe_rule :manage? do
    succeed 'when user is project owner' do
      before { record.project.user = user }
    end

    succeed 'when user is admin' do
      before { user.admin = true }
    end

    succeed 'when user is applicant' do
      before { record.user = user }
    end

    failed 'when not applicant'
  end
end