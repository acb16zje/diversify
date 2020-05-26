# frozen_string_literal: true

require 'rails_helper'

describe Suggest do
  describe '#call' do
    let(:user) { create(:user, :with_personality) }

    let(:project) { create(:project, user: user) }
    let(:team) { create(:team, project: project) }

    let(:skill) { create(:skill) }

    before { user.skills << skill }

    %w[balance cohesion efficient].each do |mode|
      subject do
        described_class.new(User.teams_data(project),
                            project.teams.where.not(name: 'Unassigned'),
                            project.unassigned_team, mode)
                       .call
      end

      context "when in unassigned with #{mode} mode" do
        before { team.skills << skill }

        it do
          is_expected.to eq(
            { team.id.to_s => [user], unassigned_team.id.to_s => [] }
          )
        end
      end

      context "when in unassigned and no compatible team #{mode} mode" do
        it do
          is_expected.to eq(
            { team.id.to_s => [], unassigned_team.id.to_s => [user] }
          )
        end
      end
    end
  end
end
