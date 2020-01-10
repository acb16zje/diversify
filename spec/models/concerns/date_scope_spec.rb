# frozen_string_literal: true

require 'rails_helper'

describe DateScope do
  let(:today) { Time.zone.today }
  let(:yesterday) { Time.zone.yesterday }
  let(:tomorrow) { Time.zone.tomorrow }

  # Any models will do, to test created_at column only
  let(:object) { create(:newsletter_subscription, created_at: today) }

  describe '.between_date' do
    subject(:model) { object.class }

    context 'when created_at < start_date' do
      subject { model.between_date('created_at', tomorrow, tomorrow + 1.day) }

      it { is_expected.not_to include(object) }
    end

    context 'when created_at == start_date' do
      subject { model.between_date('created_at', today, tomorrow) }

      it { is_expected.to include(object) }
    end

    context 'when start_date < created_at < end_date' do
      subject { model.between_date('created_at', yesterday, tomorrow) }

      it { is_expected.to include(object) }
    end

    context 'when created_at == end_date' do
      subject { model.between_date('created_at', yesterday, today) }

      it { is_expected.to include(object) }
    end

    context 'when created_at > end_date' do
      subject { model.between_date('created_at', yesterday - 1.day, yesterday) }

      it { is_expected.not_to include(object) }
    end
  end
end
