# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendNotificationJob, type: :job do
  describe '#perform_later' do
    let(:target) do
      described_class.perform_later(
        [user], { key: 'team', notifiable: project, notifier: team }
      )
    end

    let(:user) { create(:user) }
    let(:project) { create(:project) }
    let(:team) { create(:team) }

    ActiveJob::Base.queue_adapter = :test

    it { expect { target }.to enqueue_job }
  end
end
