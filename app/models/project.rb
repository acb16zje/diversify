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
  has_many :reviews, dependent: :destroy
  has_one_attached :avatar
  has_many :teams, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :invites, dependent: :destroy

  validates :name, presence: true
  validates :status, presence: true

  def status
    super.capitalize
  end
  validates :avatar, content_type: %w[image/png image/jpg image/jpeg],
                     size: { less_than: 200.kilobytes }

  before_commit :create_unassigned_team, on: :create

  def applicable?
    status == 'Open' && visibility
  end

  private

  def create_unassigned_team
    teams.create(name: 'Unassigned', team_size: 999)
  end
end
