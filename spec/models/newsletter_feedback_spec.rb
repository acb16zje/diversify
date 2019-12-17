# == Schema Information
#
# Table name: newsletter_feedbacks
#
#  id         :bigint           not null, primary key
#  email      :string           default(""), not null
#  reason     :string           default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe NewsletterFeedback do
  let(:feedback1) { build(:newsletter_feedback, no_longer: true) }

  describe '#count_reason' do
    it 'count and group the reasons' do
      expect(described_class
         .count_reason([feedback1])['I no longer want to receive these emails'])
        .to eq(1)
    end
  end
end
