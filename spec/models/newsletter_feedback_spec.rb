# frozen_string_literal: true

# == Schema Information
#
# Table name: newsletter_feedbacks
#
#  id                         :bigint           not null, primary key
#  email                      :string           default(""), not null
#  reasons                    :string           default([]), not null, is an Array
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  newsletter_subscription_id :bigint           not null
#
# Indexes
#
#  index_newsletter_feedbacks_on_newsletter_subscription_id  (newsletter_subscription_id)
#
# Foreign Keys
#
#  fk_rails_...  (newsletter_subscription_id => newsletter_subscriptions.id)
#

require 'rails_helper'

describe NewsletterFeedback, type: :model do
  let(:feedback) { build(:newsletter_feedback, :no_longer) }

  describe 'associations' do
    it { is_expected.to belong_to(:newsletter_subscription).optional }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:reasons) }
    it { is_expected.to allow_value(%w[no_longer admin]).for(:reasons) }
    it { is_expected.not_to allow_value(%w[foo bar]).for(:reasons) }
  end

  describe '#count_reason' do
    it 'count and group the reasons' do
      expect(
        described_class.count_reason([feedback])['I no longer want to receive these emails']
      ).to eq(1)
    end
  end

  describe 'before_save hook' do
    describe '#validate_subscription_status' do
      it 'save if subscribed?' do
        feedback.save
        expect(feedback).not_to be_new_record
      end

      it 'does not save unless subscribed?' do
        feedback_not_subscribed = build(:newsletter_feedback, :not_subscribed)
        feedback_not_subscribed.save
        expect(feedback_not_subscribed).to be_new_record
      end
    end
  end

  describe 'after_commit hook' do
    describe '#change_subscribed_to_false' do
      it { expect(feedback.newsletter_subscription).to be_subscribed }

      it 'change to false after commit' do
        feedback.save
        expect(feedback.newsletter_subscription).not_to be_subscribed
      end
    end
  end
end
