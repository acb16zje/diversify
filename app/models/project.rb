# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  description :text             default(""), not null
#  name        :string           default(""), not null
#  status      :enum             default("Active"), not null
#  visibility  :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint
#  user_id     :bigint
#
# Indexes
#
#  index_projects_on_category_id  (category_id)
#  index_projects_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (user_id => users.id)
#

class Project < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :teams
  has_many :reviews
  has_many :tasks
  has_one_attached :avatar

  validates :name, presence: true
  validates :status, presence: true
end
