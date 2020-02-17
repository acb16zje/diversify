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
#  index_licenses_on_user_id  (user_id)
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
        .with_values(free: 'free', pro: 'pro', enterprise: 'enterprise')
        .backed_by_column_of_type(:enum)
    }

    it { is_expected.to validate_presence_of(:plan) }
    it { is_expected.to validate_presence_of(:user_id) }

    describe 'UNIQUE user' do
      before { create(:user) }

      it { is_expected.to validate_uniqueness_of(:user_id) }
    end
  end
end
