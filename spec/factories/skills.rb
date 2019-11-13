# == Schema Information
#
# Table name: skills
#
#  id          :bigint           not null, primary key
#  description :text             default(""), not null
#  name        :string           default(""), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint
#
# Indexes
#
#  index_skills_on_category_id  (category_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#

FactoryBot.define do
  factory :skill do
    
  end
end
