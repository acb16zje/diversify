# frozen_string_literal: true

# == Schema Information
#
# Table name: licenses
#
#  id         :bigint           not null, primary key
#  plan       :enum             default("free"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_licenses_on_user_id  (user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

require 'rails_helper'

describe License, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
  end

  describe 'validations' do
    it {
      is_expected.to define_enum_for(:plan)
        .with_values(free: 'free', pro: 'pro', ultimate: 'ultimate')
        .backed_by_column_of_type(:enum)
    }

    it { is_expected.to validate_presence_of(:plan) }
    it { is_expected.to validate_presence_of(:user_id) }

    describe 'UNIQUE user_id' do
      before { create(:user) }

      it { is_expected.to validate_uniqueness_of(:user_id) }
    end
  end

  describe '#member_limit' do
    subject { license.member_limit }

    context 'when free' do
      let(:license) { build_stubbed(:license) }

      it { is_expected.to eq(10) }
    end

    context 'when pro' do
      let(:license) { build_stubbed(:license, :pro) }

      it { is_expected.to eq(30) }
    end

    context 'when ultimate' do
      let(:license) { build_stubbed(:license, :ultimate) }

      it { is_expected.to eq(1 / 0.0) }
    end
  end
end
