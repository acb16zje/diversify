# frozen_string_literal: true

require 'rails_helper'

describe InvitePolicy, type: :policy do
  let(:user) { build_stubbed :user }
  let(:record) { create(:invite) }

  let(:context) { { user: user } }

  describe_rule :create? do
    succeed 'when record is valid invite' do
      before { record.project.user = user }
    end

    succeed 'when record is valid aplication' do
      before do
        record.types = 'Application'
        record.project.status = 'open'
        record.user = user
      end
    end

    failed 'when user is invalid' do
      before { record.user = nil }
    end
  end

  describe_rule :accept? do
    succeed 'when accepting invitiation' do
      before { record.user = user }
    end

    succeed 'when accepting aplication as owner' do
      before do
        record.user = build_stubbed :user
        record.project.user = user
        record.types = 'Application'
      end
    end

    succeed 'when accepting as admin' do
      before { user.admin = true }
    end

    failed 'when not owner nor target user'
  end

  describe_rule :destroy? do
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