# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                         :bigint           not null, primary key
#  admin                      :boolean          default(FALSE)
#  birthdate                  :date
#  email                      :string           default(""), not null
#  encrypted_password         :string           default(""), not null
#  name                       :string           default(""), not null
#  password_automatically_set :boolean          default(FALSE), not null
#  remember_created_at        :datetime
#  reset_password_sent_at     :datetime
#  reset_password_token       :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

# User model
class User < ApplicationRecord
  has_many :projects, dependent: :destroy
  has_many :user_personalities, dependent: :destroy
  has_many :personalities, through: :user_personalities
  has_many :preferences, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :skill_levels, dependent: :destroy
  # has_and_belongs_to_many :teams
  has_many :reviews, dependent: :destroy
  has_one :license, dependent: :destroy
  has_many :identities, dependent: :destroy
  has_one_attached :avatar

  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2 twitter facebook]

  after_commit :disable_password_automatically_set,
               on: :update,
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
    identities.where(provider: provider).present?
  end

  def newsletter_subscribed?
    NewsletterSubscription.find_by(email: email)&.subscribed?
  end

  private

  def disable_password_automatically_set
    return unless password_automatically_set

    update(password_automatically_set: false)
  end
end
