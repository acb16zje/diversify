# frozen_string_literal: true

require 'rails_helper'

describe CompatibilityCompute, type: :service do
  describe '#call' do
    subject do
      described_class.new(project.teams, project.unassigned_team)
                     .call(User.teams_data(project).find(user.id))
    end

    let(:user) { create(:user, :with_personality) }

    let(:project) { create(:project) }
    let(:team) { create(:team, project: project) }

    let(:skill) { create(:skill) }

    before { user.skills << skill }

    context 'when no other team' do
      before { project.unassigned_team.users << user }

      it { is_expected.to eq('') }
    end

    context 'when in unassigned' do
      before do
        project.unassigned_team.users << user
        team.skills << skill
      end

      it { is_expected.to eq("(1.2) Team #{team.name}") }
    end

    context 'when in unassigned and no compatible team' do
      before do
        project.unassigned_team.users << user
        team
      end

      it { is_expected.to eq('') }
    end

    context 'when in team' do
      before do
        team.skills << skill
        team.users << user
      end

      it { is_expected.to eq('1.2') }
    end

    context 'when in team with other members' do
      let(:user2) { create(:user) }

      before do
        team.users << user
        team.users << user2
        user2.personality = create(:personality, :enfp)
        user2.save
      end

      it { is_expected.to eq('1.2') }
    end
  end
end
