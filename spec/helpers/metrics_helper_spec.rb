# frozen_string_literal: true

require 'rails_helper'

describe MetricsHelper do
  describe '#config_setter' do
    let(:graph) { MetricsHelper::GRAPH_CONFIG }

    it { expect(helper.config_setter('Newsletter')).to eq(graph[:Newsletter]) }

    it { expect(helper.config_setter('Null')).to eq(graph[:Newsletter]) }
  end

  describe '#data_setter' do
    it { expect(helper.data_setter('Reason').size).to eq(1) }

    it { expect(helper.data_setter('Landing Page').size).to eq(3) }

    it { expect(helper.data_setter('by Newsletter').size).to eq(1) }

    it { expect(helper.data_setter('Newsletter').size).to eq(2) }

    it { expect(helper.data_setter('Subscription').size).to eq(1) }

    it { expect(helper.data_setter('Visits').size).to eq(1) }

    it { expect(helper.data_setter('Average Time Spent').size).to eq(1) }

    it { expect(helper.data_setter('Referrers').size).to eq(1) }

    it { expect(helper.data_setter('Null')).to eq([]) }
  end

  describe '#decide_layout' do
    it {
      expect(helper.decide_layout('Landing Page')).to eq('metrics/_feedback.haml')
    }

    it {
      expect(helper.decide_layout('by Date')).to eq('metrics/_linegraph.haml')
    }

    it {
      expect(helper.decide_layout('per Page')).to eq('metrics/_barchart.haml')
    }

    it {
      expect(helper.decide_layout('Null')).to eq('metrics/_piechart.haml')
    }
  end

  describe '#has_data?' do
    it { expect(helper.has_data?([])).to eq false }

    it {
      create(:subscriber)
      expect(helper.has_data?(helper.data_setter('Newsletter'))).to eq true
    }
  end

  describe '#time_constraint' do
    let(:feedback_yesterday) { create(:landing_feedback, :yesterday) }
    let(:feedback_today) { create(:landing_feedback) }
    let(:record) { LandingFeedback.all }
    let(:data) { [{ data: record }] }
    let(:data_array) { [{ data: record.to_a }] }

    let(:two_days_before) { (Time.now - 2.days).to_s }
    let(:today) { Time.now.to_s }

    before do
      feedback_yesterday
      feedback_today
      data
      two_days_before
      today
    end

    context 'with datalist as array' do
      it {
        controller.params[:time] = [two_days_before, today]
        expect(helper.time_constraint('created_at', data_array)[0][:data])
          .to eq([feedback_yesterday, feedback_today])
      }
    end

    context 'with 1 date' do
      it {
        controller.params[:time] = [today]
        expect(helper.time_constraint('created_at', data)[0][:data])
          .to eq([feedback_today])
      }
    end

    context 'with 2 dates' do
      it {
        controller.params[:time] = [two_days_before, today]
        expect(helper.time_constraint('created_at', data)[0][:data])
          .to eq([feedback_yesterday, feedback_today])
      }
    end
  end

end
