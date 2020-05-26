# frozen_string_literal: true

require 'rails_helper'

describe Suggest, type: :service do
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

      context "when compabitle team with #{mode} mode" do
        before { team.skills << skill }

        it do
          is_expected.to eq(
            { team.id.to_s => [user], project.unassigned_team.id.to_s => [] }
          )
        end
      end

      context "when no compatible team #{mode} mode" do
        it do
          is_expected.to eq(
            { project.unassigned_team.id.to_s => [user] }
          )
        end
      end

      context "when with other members with benefical personality #{mode} mode" do
        let(:user2) { create(:user) }

        before do
          team.users << user2
          user2.personality = create(:personality, :enfp)
          user2.save
        end

        it do
          is_expected.to eq(
            { team.id.to_s => [user, user2], project.unassigned_team.id.to_s => [] }
          )
        end
      end

      context "when with other members with non benefical personality #{mode} mode" do
        let(:user2) { create(:user) }

        before do
          team.users << user2
          user2.personality = create(:personality, :istj)
          user2.save
        end

        it do
          is_expected.to eq(
            { team.id.to_s => [user], project.unassigned_team.id.to_s => [user2] }
          )
        end
      end

      context "when with other members with same skills #{mode} mode" do
        let(:user2) { create(:user) }
        let(:team2) { create(:team, project: project) }
        let(:skill2) { create(:skill) }
        let(:skill3) { create(:skill) }

        before do
          team.skills << skill
          team.skills << skill3

          team2.skills << skill2
          team2.skills << skill3

          user2.skills << skill
          user2.skills << skill2
          user2.skills << skill3

          team2.users << user2
          user2.personality = create(:personality, :enfp)
          user2.save
        end

        it do
          is_expected.to eq(
            { team.id.to_s => [user], project.unassigned_team.id.to_s => [],
              team2.id.to_s => [user2] }
          )
        end
      end
    end
  end
end
