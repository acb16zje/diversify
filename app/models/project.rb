# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  description :text             default(""), not null
#  name        :string           default(""), not null
#  status      :enum             default("active"), not null
#  visibility  :boolean          default(TRUE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint
#  user_id     :bigint           not null
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
  enum status: { open: 'open', active: 'active', completed: 'completed' }

  belongs_to :user
  belongs_to :category

  has_one_attached :avatar
  has_many :teams, dependent: :destroy
  has_many :tasks, dependent: :destroy

  validates :name, presence: true
  validates :status, presence: true

  def status
    super.capitalize
  end
end
