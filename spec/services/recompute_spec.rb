# frozen_string_literal: true

require 'rails_helper'

describe Recompute do
  describe '#call' do
    let(:user) { create(:user, :with_personality) }

    let(:project) { create(:project) }
    let(:team) { create(:team, project: project) }

    let(:skill) { create(:skill) }

    before { user.skills << skill }

    %w[balance cohesion efficient].each do |mode|
      subject do
        described_class.new(project.teams, project.unassigned_team, mode)
                       .call(project.unassigned_team, json)
      end

      context "when in unassigned with #{mode} mode" do
        let(:json) do
          { project.unassigned_team.id.to_s => [
            { 'id' => user.id, 'team_id' => project.unassigned_team.id }
          ], team.id.to_s => [] }
        end

        before do
          project.unassigned_team.users << user
          team.skills << skill
        end

        it { is_expected.to eq([[user.id, "(1.2) Team #{team.name}"]]) }
      end

      context "when in unassigned and no compatible team #{mode} mode" do
        let(:json) do
          { project.unassigned_team.id.to_s => [
            { 'id' => user.id, 'team_id' => project.unassigned_team.id }
          ], team.id.to_s => [] }
        end

        before { project.unassigned_team.users << user }

        it { is_expected.to eq([[user.id, '']]) }
      end

      context 'when in team' do
        score = { 'balance' => '1.2', 'cohesion' => '1.1', 'efficient' => '1.3' }

        subject do
          described_class.new(project.teams, project.unassigned_team, mode)
                         .call(team, json)
        end

        let(:json) do
          { project.unassigned_team.id.to_s => [], team.id.to_s => [
            { 'id' => user.id, 'team_id' => project.unassigned_team.id }
          ] }
        end

        before do
          project.unassigned_team.users << user
          team.skills << skill
        end

        it { is_expected.to eq([[user.id, score[mode]]]) }
      end

      context 'when in team with another member' do
        score = { 'balance' => '1.2', 'cohesion' => '1.3', 'efficient' => '1.1' }

        subject do
          described_class.new(project.teams, project.unassigned_team, mode)
                         .call(team, json)
        end

        let(:user2) { create(:user) }

        let(:json) do
          { project.unassigned_team.id.to_s => [], team.id.to_s => [
            { 'id' => user.id, 'team_id' => project.unassigned_team.id },
            { 'id' => user2.id, 'team_id' => team.id }
          ] }
        end

        before do
          project.unassigned_team.users << user
          team.users << user2
          user2.personality = create(:personality, :enfp)
          user2.save
        end

        it { is_expected.to eq([[user.id, score[mode]], [user2.id, score[mode]]]) }
      end
    end
  end
end
