# frozen_string_literal: true

require 'rails_helper'

describe ApplicationPolicy, type: :policy do
  let(:user) { build_stubbed(:user) }

  # Any record that belongs to user will do
  let(:record) { build_stubbed(:project) }

  let(:context) { { user: user } }

  describe_rule :owner? do
    failed 'when record does not belongs to user'

    failed 'when user is nil' do
      let(:user) { nil }
    end

    succeed 'when record belongs to user' do
      before { record.user = user }
    end
  end
end
