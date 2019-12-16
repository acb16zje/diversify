# == Schema Information
#
# Table name: newsletter_subscriptions
#
#  id              :bigint           not null, primary key
#  date_subscribed :date             default(Mon, 16 Dec 2019), not null
#  email           :string           not null
#  subscribed      :boolean          default(TRUE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_newsletter_subscriptions_on_email  (email) UNIQUE
#

require 'rails_helper'

describe NewsletterSubscription do
  include ActiveJob::TestHelper

  before { clear_enqueued_jobs }

  describe '#send_newsletter' do
    let(:subscriber) { create(:subscriber) }
    let(:newsletter) { create(:newsletter) }
    let(:job) { described_class.send_newsletter(newsletter) }

    before { subscriber }

    it 'a job is created' do
      expect { job }.to have_enqueued_job.on_queue('mailers')
    end

    it 'newsletter is sent' do
      expect { perform_enqueued_jobs { job } }
        .to change { ActionMailer::Base.deliveries.size }.by(1)
    end
  end

end
