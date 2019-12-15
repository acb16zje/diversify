# frozen_string_literal: true

# == Schema Information
#
# Table name: skill_levels
#
#  id         :bigint           not null, primary key
#  experience :integer          default(0), not null
#  level      :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  skill_id   :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_skill_levels_on_skill_id  (skill_id)
#  index_skill_levels_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (skill_id => skills.id)
#  fk_rails_...  (user_id => users.id)
#

FactoryBot.define do
  factory :skill_level do
  end
end
