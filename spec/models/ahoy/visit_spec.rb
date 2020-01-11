# frozen_string_literal: true

# == Schema Information
#
# Table name: ahoy_visits
#
#  id               :bigint           not null, primary key
#  app_version      :string
#  browser          :string
#  city             :string
#  country          :string
#  device_type      :string
#  ip               :string
#  landing_page     :text
#  latitude         :float
#  longitude        :float
#  os               :string
#  os_version       :string
#  platform         :string
#  referrer         :text
#  referring_domain :string
#  region           :string
#  started_at       :datetime
#  user_agent       :text
#  utm_campaign     :string
#  utm_content      :string
#  utm_medium       :string
#  utm_source       :string
#  utm_term         :string
#  visit_token      :string
#  visitor_token    :string
#  user_id          :bigint
#
# Indexes
#
#  index_ahoy_visits_on_user_id      (user_id)
#  index_ahoy_visits_on_visit_token  (visit_token) UNIQUE
#

require 'rails_helper'

describe Ahoy::Visit, type: :model do
  describe 'modules' do
    it { is_expected.to include_module(DateScope) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:events) }
    it { is_expected.to belong_to(:user).optional }
  end

  describe 'scopes' do
    describe '.today_count' do
      subject(:model) { described_class }

      let(:today) { create(:ahoy_visit, :today) }
      let(:yesterday) { create(:ahoy_visit, :yesterday) }
      let(:tomorrow) { create(:ahoy_visit, :tomorrow) }

      it { expect{ today }.to change(model, :today_count).by(1) }
      it { expect{ yesterday }.to change(model, :today_count).by(0) }
      it { expect{ tomorrow }.to change(model, :today_count).by(0) }
    end
  end
end
