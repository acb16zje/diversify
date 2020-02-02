# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  admin                  :boolean          default(FALSE)
#  birthdate              :date
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

FactoryBot.define do
  factory :user do
    email { generate(:email) }
    password { '12345678' }
    name { generate(:name) }
  end

  trait :admin do
    admin { true }
  end

  factory :omniauth_user, parent: :user do
    transient do
      no_password { false }
      uid { '1234' }
      providers { ['test'] }
    end

    after(:create) do |user, evaluator|
      if evaluator.no_password
        user.encrypted_password = ''
        user.skip_password_validation = true
      end

      evaluator.providers.each do |provider|
        identity_attrs = {
          provider: provider,
          uid: evaluator.uid,
          user: user
        }

        create(:identity, identity_attrs)
      end
    end
  end

  factory :admin, traits: [:admin]
end
