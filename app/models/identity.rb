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

# Identity model, for OAuth
class Identity < ApplicationRecord
  belongs_to :user

  validates :provider, presence: true
  validates :uid,
            presence: true,
            uniqueness: { scope: :provider, message: 'Account has been taken' }
  validates :user_id,
            presence: true,
            uniqueness: { scope: :provider, message: 'Account has been taken' }
end
