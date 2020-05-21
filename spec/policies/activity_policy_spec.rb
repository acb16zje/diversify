# frozen_string_literal: true

require 'rails_helper'

describe ActivityPolicy, type: :policy do
  let(:context) { { user: user } }

  describe 'relation_scope' do
    let(:data) { policy.apply_scope(target, type: :active_record_relation) }
    let(:user) { create(:user) }
    let(:user2) { create(:user) }
    let(:project) { build_stubbed(:project) }
    let(:target) { user.activities.from_month(DateTime.current) }

    before do
      create(:activity, user: user, key: 'task/1')
      create(:activity, user: user2, key: 'project/complete')
    end

    it { expect(data[0].to_a.size).to eq(1) }
    it { expect(data[1].size).to eq(1) }
  end
end
