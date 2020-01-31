# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  admin                  :boolean          default(FALSE)
#  birthdate              :date
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

# User model
class User < ApplicationRecord
  # virtual attribute to skip password validation while saving
  attr_accessor :skip_password_validation

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

  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
  # validates :encrypted_password, presence: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2 twitter facebook]

  def oauth_provider_connected?(provider = nil)
    Identity.exists?(user: self, provider: provider)
  end

  def newsletter_subscribed?
    subscription = NewsletterSubscription.find_by(email: email)
    subscription.present? && subscription.subscribed
  end

  protected

  def password_required?
    return false if skip_password_validation

    super
  end
end
