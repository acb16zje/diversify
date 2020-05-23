# frozen_string_literal: true

# == Schema Information
#
# Table name: notifications
#
#  id              :bigint           not null, primary key
#  key             :string           default("")
#  notifiable_type :string           not null
#  notifier_type   :string           not null
#  read            :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  notifiable_id   :bigint           not null
#  notifier_id     :bigint           not null
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
class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true
  belongs_to :notifier, polymorphic: true

  scope :unread, -> { where(read: false) }

  # TODO: tasks may not have avatar attachment, so the eager load wont work
  scope :load_index, -> { includes(:notifier, notifiable: [{ avatar_attachment: :blob }]) }
end
