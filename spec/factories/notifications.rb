# == Schema Information
#
# Table name: notifications
#
#  id              :bigint           not null, primary key
#  key             :string           default("")
#  notifiable_type :string
#  notifier_type   :string
#  opened_at       :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  notifiable_id   :bigint
#  notifier_id     :bigint
#  user_id         :bigint           not null
#
# Indexes
#
#  index_notifications_on_notifiable_type_and_notifiable_id  (notifiable_type,notifiable_id)
#  index_notifications_on_notifier_type_and_notifier_id      (notifier_type,notifier_id)
#  index_notifications_on_user_id                            (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :notification do
    association :user, factory: :user
    # Notifier and Notifiable are polymorphic, using project and invite as
    # default for ease of testing
    association :notifier, factory: :project
    association :notifiable, factory: :invite
  end
end
