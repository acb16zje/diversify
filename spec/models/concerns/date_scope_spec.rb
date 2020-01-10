# frozen_string_literal: true

require 'rails_helper'

describe DateScope do
  describe 'scopes' do
    let(:today) { Time.zone.today }
    let(:yesterday) { Time.zone.yesterday }
    let(:tomorrow) { Time.zone.tomorrow }

    # Any models will do, need created_at column only
    let(:object) { create(:newsletter_subscription, created_at: today) }

    describe '.between_date' do
      subject(:model) { object.class }

      specify 'created_at < start_date' do
        expect(
          model.between_date('created_at', tomorrow, tomorrow + 1.day)
        ).not_to include(object)
      end

      specify 'created_at == start_date' do
        expect(
          model.between_date('created_at', today, tomorrow)
        ).to include(object)
      end

      specify 'start_date < created_at < end_date' do
        expect(
          model.between_date('created_at', yesterday, tomorrow)
        ).to include(object)
      end

      specify 'created_at == end_date' do
        expect(
          model.between_date('created_at', yesterday, today)
        ).to include(object)
      end

      specify 'created_at > end_date' do
        expect(
          model.between_date('created_at', yesterday - 1.day, yesterday)
        ).not_to include(object)
      end
    end
  end
end
