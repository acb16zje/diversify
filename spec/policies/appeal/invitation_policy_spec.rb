# frozen_string_literal: true

require 'rails_helper'

describe Appeal::InvitationPolicy, type: :policy do
  let(:user) { build_stubbed(:user) }
  let(:record) { build_stubbed(:invitation) }

  let(:context) { { user: user } }

  describe_rule :create? do
    failed 'when user is not project owner and not admin'

    succeed 'when user is project owner' do
      before { record.project.user = user }
    end

    succeed 'when user is admin' do
      before { user.admin = true }
    end
  end

  describe_rule :accept? do
    failed 'when user is not invitation owner and not admin'

    failed 'when user is project owner, not invitation owner and not admin' do
      before { record.project.user = user }
    end

    succeed 'when user is invitation owner and not project owner' do
      before { record.user = user }
    end

    succeed 'when user is admin' do
      before { user.admin = true }
    end
  end
end
