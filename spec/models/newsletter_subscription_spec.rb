# frozen_string_literal: true

# == Schema Information
#
# Table name: newsletter_subscriptions
#
#  id         :bigint           not null, primary key
#  email      :string           not null
#  subscribed :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_newsletter_subscriptions_on_email  (email) UNIQUE
#

require 'rails_helper'

describe NewsletterSubscription, type: :model do
  include ActiveJob::TestHelper

  describe 'associations' do
    it { is_expected.to have_many(:newsletter_feedbacks).dependent(:nullify) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to allow_value('foo@bar.com').for(:email) }
    it { is_expected.not_to allow_value('foobar').for(:email) }
  end

  describe 'scopes' do
    # Local variable to share across examples
    subscribed = described_class.create(email: '1@1.com')
    unsubscribed = described_class.create(email: '2@1.com', subscribed: false)

    describe '.all_subscribed_emails' do
      subject { described_class.all_subscribed_emails }

      it { is_expected.to include(subscribed.email) }
      it { is_expected.not_to include(unsubscribed.email) }
    end

    describe '.previously_subscribed' do
      subject { described_class.previously_subscribed.pluck(:email) }

      it { is_expected.to include(unsubscribed.email) }
      it { is_expected.not_to include(subscribed.email) }
    end

    describe '.subscribed_count' do
      subject { described_class.subscribed_count }

      it { is_expected.to eq 1 }
    end
  end

  describe 'after_commit hook' do
    describe '#send_welcome', type: :mailer do
      it 'send welcome email on create' do
        expect do
          create(:newsletter_subscription)
        end.to have_enqueued_mail(NewsletterMailer, :send_welcome)
      end
    end
  end

  describe '#self.subscribe' do
    context 'when new_record' do
      let(:email) { generate(:email) }

      before { described_class.subscribe(email) }

      it { expect(described_class.all_subscribed_emails).to include(email) }
    end

    context 'when subscribed' do
      subject(:subscription) { create(:newsletter_subscription) }

      before do
        described_class.subscribe(subscription.email)
        subscription.reload
      end

      it { is_expected.to be_subscribed }
    end

    context 'when not subscribed' do
      subject(:subscription) { create(:newsletter_subscription, :unsubscribed) }

      before do
        described_class.subscribe(subscription.email)
        subscription.reload
      end

      it { is_expected.to be_subscribed }
    end
  end

  describe '#unsubscribe' do
    context 'when subscribed' do
      subject(:subscription) { build(:newsletter_subscription) }

      before { subscription.unsubscribe }

      it { is_expected.not_to be_subscribed }
    end

    context 'when not subscribed' do
      subject(:subscription) { build(:newsletter_subscription, :unsubscribed) }

      before { subscription.unsubscribe }

      it { is_expected.not_to be_subscribed }
    end
  end
end
