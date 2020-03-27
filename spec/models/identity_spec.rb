# frozen_string_literal: true

# == Schema Information
#
# Table name: identities
#
#  id         :bigint           not null, primary key
#  provider   :string
#  uid        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_identities_on_provider_and_uid      (provider,uid) UNIQUE
#  index_identities_on_provider_and_user_id  (provider,user_id) UNIQUE
#  index_identities_on_user_id               (user_id)
#


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
      subject(:identity) do
        build_stubbed(:identity, provider: 'test', uid: 1, user: second_user)
      end

      before { Identity.create(provider: 'test', uid: 1, user: first_user) }

      it 'returns false for duplicate entry' do
        expect(identity.validate).to be_falsey
      end
    end

    describe 'UNIQUE provider, user_id' do
      subject(:identity) do
        build_stubbed(:identity, provider: 'test', uid: 2, user: first_user)
      end

      before { Identity.create(provider: 'test', uid: 1, user: first_user) }

      it 'returns false for duplicate entry' do
        expect(identity.validate).to be_falsey
      end
    end
  end
end
