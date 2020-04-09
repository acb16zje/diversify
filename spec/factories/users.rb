# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                         :bigint           not null, primary key
#  admin                      :boolean          default(FALSE)
#  birthdate                  :date
#  email                      :string           default(""), not null
#  encrypted_password         :string           default(""), not null
#  name                       :string           default(""), not null
#  password_automatically_set :boolean          default(FALSE), not null
#  remember_created_at        :datetime
#  reset_password_sent_at     :datetime
#  reset_password_token       :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  personality_id             :bigint
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_personality_id        (personality_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (personality_id => personalities.id)
#

FactoryBot.define do
  factory :user do
    email { generate(:email) }
    password { '12345678' }
    name { generate(:name) }

    trait :newsletter do
      after(:create) do |user|
        create(:newsletter_subscription, email: user.email)
      end
    end

    trait :with_personality do
      personality
    end

    trait :with_avatar do
      avatar { Rack::Test::UploadedFile.new('spec/fixtures/squirtle.png') }
    end
  end

  factory :omniauth_user, parent: :user do
    password_automatically_set { true }

    trait :has_password do
      password_automatically_set { false }
    end

    transient do
      uid { '1234' }
      providers { ['test'] }
    end

    after(:create) do |user, evaluator|
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

  factory :admin, parent: :user do
    admin { true }
  end
end
