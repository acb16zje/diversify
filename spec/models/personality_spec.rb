# frozen_string_literal: true

# == Schema Information
#
# Table name: personalities
#
#  id         :bigint           not null, primary key
#  energy     :enum
#  mind       :enum
#  nature     :enum
#  tactic     :enum
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_personalities_on_mind_and_energy_and_nature_and_tactic  (mind,energy,nature,tactic) UNIQUE
#

require 'rails_helper'

describe Personality, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:users) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:mind) }
    it { is_expected.to validate_presence_of(:energy) }
    it { is_expected.to validate_presence_of(:nature) }
    it { is_expected.to validate_presence_of(:tactic) }

    it { is_expected.to validate_inclusion_of(:mind).in_array(%w[I E]) }
    it { is_expected.to validate_inclusion_of(:energy).in_array(%w[S N]) }
    it { is_expected.to validate_inclusion_of(:nature).in_array(%w[T F]) }
    it { is_expected.to validate_inclusion_of(:tactic).in_array(%w[J P]) }
  end

  describe '#to_type' do
    let(:personality) { build_stubbed(:personality) }

    it { expect(personality.to_type).to eq('Architect') }
  end

  describe '#trait' do
    let(:personality) { build_stubbed(:personality) }

    it { expect(personality.trait).to eq('INTJ') }
  end
end
