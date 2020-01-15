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
  has_many :projects
  has_many :user_personalities, dependent: :destroy
  has_many :personalities, through: :user_personalities
  has_many :preferences, dependent: :destroy
  has_many :tasks
  has_many :skill_levels, dependent: :destroy
  # has_and_belongs_to_many :teams
  has_many :reviews
  has_one :license
  has_many :identities, dependent: :destroy

  attr_accessor :skip_password_validation # virtual attribute to skip password validation while saving

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

  def oauth?(provider=nil)
    if provider.nil?
      Identity.exists?(user: self)
    else
      Identity.exists?(user: self, provider: provider)
    end
  end

  def subscribed_newsletter?
    subscription = NewsletterSubscription.find_by(email: email)
    !subscription.nil? && subscription.subscribed == true
  end

  protected

  def password_required?
    return false if skip_password_validation

    super
  end
end
