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

FactoryBot.define do
  factory :identity do
    provider { 'test' }
    uid { '1234' }
  end
end
