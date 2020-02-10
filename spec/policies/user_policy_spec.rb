# frozen_string_literal: true

require 'rails_helper'

describe UserPolicy, type: :policy do
  let(:user) { build_stubbed(:user) }

  let(:context) { { user: user } }

  describe_rule :show? do
    succeed 'when user is the signed in user' do
      let(:record) { user }
    end

    succeed 'when user is other user' do
      let(:record) { build_stubbed(:user) }
    end
  end
end
