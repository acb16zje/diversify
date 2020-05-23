# frozen_string_literal: true

require 'rails_helper'

describe NewsletterMailer, type: :mailer do
  describe '#send_newsletter' do
    let(:newsletter) { build_stubbed(:newsletter) }
    let(:mail) { described_class.send_newsletter(%w[foo@bar.com bar@foo.com], newsletter).deliver }

    it { expect(mail.to).to eq(['no-reply@sheffield.ac.uk']) }
    it { expect(mail.bcc).to eq(%w[foo@bar.com bar@foo.com]) }
    it { expect(mail.subject).to eq(newsletter.title) }
    it { expect(mail.body.encoded).to include(newsletter.content.body.to_trix_html) }
  end

  describe '#send_welcome' do
    let(:mail) { described_class.send_welcome('foo@bar.com').deliver }

    it { expect(mail.to).to eq(['no-reply@sheffield.ac.uk']) }
    it { expect(mail.bcc).to eq(['foo@bar.com']) }
    it { expect(mail.subject).to eq('Welcome to Diversify') }
  end
end
