# frozen_string_literal: true

require 'rails_helper'

describe ComputeService do
  describe '#best_team' do
    subject { described_class.new.best_team?(user, project.teams) }

    let(:user) { create(:user, :with_personality) }
    let(:project) { create(:project, user: user) }
    let(:skill) { create(:skill) }
    let(:team) { create(:team, project: project) }

    context 'when no other teams' do
      it { is_expected.to eq('') }
    end

    context 'when incompatible team' do
      before { team }

      it { is_expected.to eq('') }
    end

    context 'when compatible team' do
      before do
        user.skills << skill
        team.skills << skill
      end

      it { is_expected.to eq("(1.2) Team #{team.name}") }
    end

    context 'when with json' do
      subject do
        described_class.new.best_team?(user, project.teams,
                                       { team.id.to_s => [user] })
      end

      before do
        user.skills << skill
        team.skills << skill
      end

      it { is_expected.to eq("(1.2) Team #{team.name}") }
    end
  end

  describe '#compare_team' do
    subject { described_class.new.compare_team(user, project.teams) }

    let(:user) { create(:user, :with_personality) }
    let(:project) { create(:project, user: user) }
    let(:skill) { create(:skill) }
    let(:team) { create(:team, project: project) }

    context 'when no other teams' do
      it { is_expected.to eq({}) }
    end

    context 'when incompatible team' do
      before { team }

      it { is_expected.to eq({ team.name.to_s => 1.0 }) }
    end

    context 'when compatible team' do
      before do
        user.skills << skill
        team.skills << skill
      end

      it { is_expected.to eq({ team.name.to_s => 1.2 }) }
    end

    context 'when with json' do
      subject do
        described_class.new.compare_team(user, project.teams,
                                         { team.id.to_s => [user] })
      end

      before do
        user.skills << skill
        team.skills << skill
      end

      it { is_expected.to eq({ team.name.to_s => 1.2 }) }
    end
  end

  describe '#team_compatibility' do
    subject { described_class.new.team_compatibility(user, team, team.users) }

    let(:user) { create(:user, :with_personality) }
    let(:user2) { create(:user) }
    let(:project) { create(:project, user: user) }
    let(:skill) { create(:skill) }
    let(:team) { create(:team, project: project) }

    context 'when team and user has no skills' do
      it { is_expected.to eq(1.0) }
    end

    context 'when team has no data' do
      before { user.skills << skill }

      it { is_expected.to eq(1.0) }
    end

    context 'when user has no skills' do
      before { team.skills << skill }

      it { is_expected.to eq(1.0) }
    end

    context 'when team has member' do
      before do
        team.users << user2
        user2.personality = create(:personality, :isfp)
      end

      it { is_expected.to eq(1.0) }
    end
  end

  describe '#teamskill_score' do
    subject { described_class.new.teamskill_score(u_ids, t_ids) }

    let(:u_ids) { [] }
    let(:t_ids) { [] }

    context 'when team and user has no skills' do
      it { is_expected.to eq(1.0) }
    end

    context 'when team has no data' do
      let(:u_ids) { [1] }

      it { is_expected.to eq(1.0) }
    end

    context 'when user has no skills' do
      let(:t_ids) { [1] }

      it { is_expected.to eq(1.0) }
    end

    context 'when compatible skill' do
      let(:u_ids) { [1] }
      let(:t_ids) { [1] }

      it { is_expected.to eq(1.2) }
    end
  end

  describe '#team_personality_score' do
    subject { described_class.new.team_personality_score(user, team.users) }

    let(:user) { create(:user, :with_personality) }
    let(:user2) { create(:user) }
    let(:project) { create(:project, user: user) }
    let(:skill) { create(:skill) }
    let(:team) { create(:team, project: project) }

    context 'when no members in team' do
      it { is_expected.to eq(1.0) }
    end

    context 'when user has no personality' do
      let(:user) { create(:user) }

      before do
        team.users << user2
        user2.personality = create(:personality, :isfp)
      end

      it { is_expected.to eq(1.0) }
    end

    context 'when team member has no personality' do
      before { team.users << user2 }

      it { is_expected.to eq(1.0) }
    end

    context 'when both has personality' do
      before do
        team.users << user2
        user2.personality = create(:personality, :enfp)
        user2.save
      end

      it { is_expected.to eq(1.2) }
    end
  end
end
