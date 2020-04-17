# frozen_string_literal: true

require 'rails_helper'

describe NotificationPolicy, type: :policy do
  let(:user) { build_stubbed(:user) }
  let(:record) { build_stubbed(:notification) }

  let(:context) { { user: user } }

  describe_rule :manage? do
    failed 'when user is not owner'

    succeed 'when user is owner' do
      before { record.user = user }
    end
  end
end
