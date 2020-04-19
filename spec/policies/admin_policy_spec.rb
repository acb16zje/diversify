# frozen_string_literal: true

require 'rails_helper'

describe AdminPolicy, type: :policy do
  let(:user) { build_stubbed :user }

  let(:context) { { user: user } }

  describe_rule :manage? do
    succeed 'when user is the admin' do
      before { user.admin = true }
    end

    failed 'when user is not admin'
  end
end
