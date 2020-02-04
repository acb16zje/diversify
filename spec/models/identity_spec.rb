# frozen_string_literal: true

require 'rails_helper'

describe Identity, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    let(:first_user) { create(:user) }
    let(:second_user) { create(:user) }

    it { is_expected.to validate_presence_of(:provider) }
    it { is_expected.to validate_presence_of(:uid) }
    it { is_expected.to validate_presence_of(:user_id) }

    describe 'UNIQUE provider, uid' do
      before { Identity.create(provider: 'test', uid: 1, user: first_user) }

      it 'returns false for duplicate entry' do
        identity = build_stubbed(:identity, provider: 'test', uid: 1,
                                            user: second_user)

        expect(identity.validate).to be_falsey
      end
    end

    describe 'UNIQUE provider, user_id' do
      before { Identity.create(provider: 'test', uid: 1, user: first_user) }

      it 'returns false for duplicate entry' do
        identity = build_stubbed(:identity, provider: 'test', uid: 2,
                                            user: first_user)

        expect(identity.validate).to be_falsey
      end
    end
  end
end
