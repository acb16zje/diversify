# frozen_string_literal: true

# == Schema Information
#
# Table name: preferences
#
#  id              :bigint           not null, primary key
#  group_size      :integer          default(0), not null
#  preferred_tasks :text             default(""), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :bigint
#
# Indexes
#
#  index_preferences_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

# Preference model
class Preference < ApplicationRecord
  belongs_to :user

  validates :group_size, numericality: { greater_than: 0 }
  validates_presence_of :preferred_tasks
end
