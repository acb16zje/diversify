# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                         :bigint           not null, primary key
#  admin                      :boolean          default(FALSE), not null
#  birthdate                  :date
#  email                      :string(254)      default(""), not null
#  encrypted_password         :string           default(""), not null
#  name                       :string(255)      default(""), not null
#  password_automatically_set :boolean          default(FALSE), not null
#  remember_created_at        :datetime
#  reset_password_sent_at     :datetime
#  reset_password_token       :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  personality_id             :bigint
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_personality_id        (personality_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (personality_id => personalities.id)
#

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: Devise.omniauth_providers

  belongs_to :personality, optional: true

  has_one_attached :avatar
  has_one :license, dependent: :destroy

  has_many :activities, dependent: :destroy
  has_many :identities, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :appeals, dependent: :destroy

  # Join table
  has_many :collaborations, dependent: :destroy
  has_many :teams, through: :collaborations
  has_many :task_users, dependent: :destroy
  has_many :tasks, through: :task_users
  has_many :user_skills, dependent: :destroy
  has_many :skills, through: :user_skills

  validates :email,
            presence: true,
            uniqueness: true,
            length: { maximum: 254 },
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :name, length: { maximum: 255 }
  validates :name, presence: true, on: :update

  validates :avatar, content_type: %w[image/png image/jpg image/jpeg],
                     size: { less_than: 200.kilobytes }

  validate :provided_birthdate, on: :update

  before_create :build_license, :build_activities

  after_update_commit :disable_password_automatically_set,
                      if: [:saved_change_to_encrypted_password?,
                           proc { |user| user.password_automatically_set }]

  def self.sign_in_omniauth(auth)
    Identity.where(provider: auth.provider, uid: auth.uid).first_or_create(
      user: create(
        email: auth.info.email,
        name: auth.info.name,
        password: Devise.friendly_token[0, 20],
        password_automatically_set: true
      )
    )
  end

  def connect_omniauth(auth)
    identities.create(provider: auth.provider, uid: auth.uid)
  end

  def oauth_provider_connected?(provider = nil)
    identities.exists?(provider: provider)
  end

  def newsletter_subscribed?
    NewsletterSubscription.find_by(email: email)&.subscribed?
  end

  def empty_compability_data?
    personality.blank? && skills.blank?
  end

  # TODO: use has_many :members, through: :teams
  def in_project?(project)
    teams&.exists?(project: project) || project&.user == self
  end

  def notifications
    super.order(id: :desc, created_at: :desc)
  end

  def compatible_with?(target_user)
    personality.compabilities[target_user.personality_id - 1]
  end

  private

  def build_activities
    activities.build(key: 'user/create')
  end

  def disable_password_automatically_set
    update_columns(password_automatically_set: false) # rubocop:disable Rails/SkipsModelValidations
  end

  def provided_birthdate
    return if birthdate_before_type_cast.blank?

    dob = Date.new(
      birthdate_before_type_cast[1], # year
      birthdate_before_type_cast[2], # month
      birthdate_before_type_cast[3]  # day of month
    )

    return errors.add(:birthdate, 'must be before the account creation date') if dob >= created_at.to_date

    age = ((Time.current - dob.to_time) / 1.year.seconds).floor
    return if age.between?(6, 80)

    errors.add(:age, 'must be between 6 and 80 years old')
  rescue StandardError
    errors.add(:date, 'is invalid')
  end
end
