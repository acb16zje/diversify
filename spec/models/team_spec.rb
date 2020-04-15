# frozen_string_literal: true

require 'rails_helper'
skills: []
describe Team, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:project) }
    it { is_expected.to have_many(:users) }
    it { is_expected.to have_many(:skills) }
  end
end
