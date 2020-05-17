# frozen_string_literal: true

# == Schema Information
#
# Table name: activities
#
#  id          :bigint           not null, primary key
#  key         :string           default("")
#  target_type :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  target_id   :bigint           not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_activities_on_target_type_and_target_id  (target_type,target_id)
#  index_activities_on_user_id                    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :project, optional: true

  def self.from_month(mth)
    where('activities.created_at >= ? AND activities.created_at <= ?',
          mth.beginning_of_month, mth.end_of_month)
  end
end
