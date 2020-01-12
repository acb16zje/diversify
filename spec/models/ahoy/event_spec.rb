# frozen_string_literal: true

# == Schema Information
#
# Table name: ahoy_events
#
#  id         :bigint           not null, primary key
#  name       :string
#  properties :jsonb
#  time       :datetime
#  user_id    :bigint
#  visit_id   :bigint
#
# Indexes
#
#  index_ahoy_events_on_name_and_time  (name,time)
#  index_ahoy_events_on_properties     (properties) USING gin
#  index_ahoy_events_on_user_id        (user_id)
#  index_ahoy_events_on_visit_id       (visit_id)
#

require 'rails_helper'

describe Ahoy::Event, type: :model do
  describe 'modules' do
    it { is_expected.to include_module(Ahoy::QueryMethods) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:visit) }
    it { is_expected.to belong_to(:user).optional }
  end

  describe 'scopes' do
    subject(:model) { described_class }

    describe '.subscriptions' do
      let(:subscription_event) { create(:ahoy_event, :free) }

      it { expect(model.subscriptions).to include(subscription_event) }
    end

    describe '.action' do
      let(:action_event) { create(:ahoy_event, :ran_action) }

      it { expect(model.action).to include(action_event) }
    end

    describe '.social' do
      let(:social_event) { create(:ahoy_event, :facebook) }

      it { expect(model.social).to include(social_event) }
    end
  end
end
