# frozen_string_literal: true

require 'rails_helper'

describe Newsletter, type: :model do
  let(:newsletter) { create(:newsletter) }

  describe 'associations' do
    it { is_expected.to have_one(:rich_text_content) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:content) }
  end

  describe 'scopes' do
    describe '.unsubscription_by_newsletter' do
      before { newsletter }

      let(:feedback_before_newsletter) do
        create(:newsletter_feedback, :no_longer,
               created_at: Time.zone.yesterday)
      end

      let(:feedback_after_newsletter) do
        create(:newsletter_feedback, :no_longer, created_at: Time.zone.tomorrow)
      end

      it 'does not return unsubscription before newsletter' do
        expect { feedback_before_newsletter }.
          to change { described_class.unsubscription_by_newsletter.size }.by 0
      end

      it 'returns unsubscription after newsletter' do
        expect { feedback_after_newsletter }.
          to change { described_class.unsubscription_by_newsletter.size }.by 1
      end
    end
  end

  describe 'after_commit hook' do
    describe '#send_newsletter', type: :mailer do
      before { create(:newsletter_subscription) }

      it 'send newsletter on create' do
        expect { newsletter }
          .to have_enqueued_mail(NewsletterMailer, :send_newsletter)
      end
    end
  end
end
