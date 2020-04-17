# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  description :text             default(""), not null
#  name        :string(100)      default(""), not null
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
  # To prevent ORDER BY injection
  SORT_BY = {
    created_asc: 'projects.created_at ASC',
    created_desc: 'projects.created_at DESC',
    name: 'projects.name ASC'
  }.freeze

  enum status: { open: 'open', active: 'active', completed: 'completed' }

  belongs_to :user
  belongs_to :category

  has_one_attached :avatar

  has_many :appeals, dependent: :destroy
  has_many :notifications, as: :notifiable, dependent: :destroy
  has_many :notifications, as: :notifier, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :users, through: :teams

  validates :name, presence: true, length: { maximum: 100 }
  validates :status, presence: true

  validates :avatar, content_type: %w[image/png image/jpg image/jpeg],
                     size: { less_than: 200.kilobytes }

  scope :search, lambda { |params|
    with_attached_avatar
      .joins(:category, :user)
      .select('projects.*')
      .select('categories.name AS category_name')
      .select('users.name AS user_name, users.email')
      .where('projects.status::text ~ ?', params[:status] || '')
      .where('categories.name ~* ?', params[:category] || '')
      .where('projects.name ~* :query OR projects.description ~* :query',
             query: params[:query] || '')
      .order(SORT_BY[params[:sort]&.to_sym] || SORT_BY[:created_desc])
  }

  before_validation :validate_status_update,
                    on: :update,
                    if: :will_save_change_to_status?

  before_commit :create_unassigned_team, on: :create

  def applicable?
    open? && visibility
  end

  def unassigned_team
    teams.find_by(name: 'Unassigned')
  end

  def check_users_limit
    return if users.size < user.license.member_limit

    errors.add(:base, 'Project is already full')
    throw :abort
  end

  private

  def validate_status_update
    if status_was != 'active' && status != 'active'
      errors.add(:base, 'Invalid status change')
      throw :abort
    end

    check_users_limit if status == 'open'
  end

  def create_unassigned_team
    teams.create(name: 'Unassigned', team_size: 999).users << user
  end
end
