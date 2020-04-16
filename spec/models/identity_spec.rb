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
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
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

    describe 'UNIQUE uid, provider' do
      subject { build(:identity, user: first_user) }

      it {
        is_expected.to validate_uniqueness_of(:uid)
          .scoped_to(:provider)
          .with_message('Account has been taken').case_insensitive
      }
    end

    describe 'UNIQUE user_id, provider' do
      subject { build(:identity, user: first_user) }

      it {
        is_expected.to validate_uniqueness_of(:user_id)
          .scoped_to(:provider)
          .with_message('Account has been taken').case_insensitive
      }
    end
  end
end
