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

  has_many :identities, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :preferences, dependent: :destroy
  has_many :skill_levels, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :invites, dependent: :destroy
  has_many :reviews,
           foreign_key: :reviewer_id,
           class_name: 'Review',
           dependent: :nullify,
           inverse_of: :reviewer

  # Join table
  has_many :collaborations, dependent: :destroy
  has_many :teams, through: :collaborations

  validates :email,
            presence: true,
            uniqueness: true,
            length: { maximum: 254 },
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :name, length: { maximum: 255 }

  validates :avatar, content_type: %w[image/png image/jpg image/jpeg],
                     size: { less_than: 200.kilobytes }

  validate :provided_birthdate, on: :update

  after_create_commit -> { create_license }

  after_update_commit :disable_password_automatically_set,
                      if: :saved_change_to_encrypted_password?

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

  def self.connect_omniauth(auth, current_user)
    Identity.create(provider: auth.provider, uid: auth.uid, user: current_user)
  end

  def oauth_provider_connected?(provider = nil)
    identities.exists?(provider: provider)
  end

  def newsletter_subscribed?
    NewsletterSubscription.find_by(email: email)&.subscribed?
  end

  # TODO: use has_many :members, through: :teams
  def in_project?(project)
    teams&.exists?(project: project) || project&.user == self
  end

  # TODO: this should be in project policy
  def can_change_visibility?
    admin || !license.free?
  end

  def self.relevant_invite(type, project)
    self.select('users.id, users.email, invites.id AS invite_id')
        .joins(:invites)
        .where(invites: { types: type, project: project })
  end

  def notifications
    super.order(created_at: :desc)
  end

  private

  def disable_password_automatically_set
    return unless password_automatically_set

    update(password_automatically_set: false)
  end

  def provided_birthdate
    return if birthdate_before_type_cast.blank?

    date = Date.new(
      birthdate_before_type_cast[1], # year
      birthdate_before_type_cast[2], # month
      birthdate_before_type_cast[3]  # day of month
    )

    if date >= created_at.to_date
      errors.add(:birthdate, 'must be before the account creation date')
      return
    end

    age = ((Time.current - date.to_time) / 1.year.seconds).floor

    return if age.between?(6, 80)

    errors.add(:age, 'must be between 6 and 80 years old')
  rescue StandardError
    errors.add(:date, 'is invalid')
  end
end
