# frozen_string_literal: true

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

# Skill model
class Skill < ApplicationRecord
  belongs_to :category
  has_and_belongs_to_many :tasks
  has_many :skill_levels

  validates :description, presence: true
  validates :name, presence: true, uniqueness: true
end
