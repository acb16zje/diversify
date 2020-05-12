# frozen_string_literal: true

require 'rails_helper'

describe ProjectObjectBlueprint, type: :serializer do
  let(:project) { build_stubbed(:project) }
  let(:task) { build_stubbed(:task, project: project) }
  let(:team) { build_stubbed(:team, project: project) }

  describe 'fields' do
    context 'when task' do
      subject { described_class.render(task) }

      it { is_expected.to include("\"name\":\"#{task.name}\"") }
    end

    context 'when team' do
      subject { described_class.render(team) }

      it { is_expected.to include("\"name\":\"#{team.name}\"") }
    end
  end

  describe 'view' do
    context 'when task is notifier' do
      subject { described_class.render(task, view: :notifier) }

      it { is_expected.to include("\"link\":\"/projects/#{project.id}\"") }
    end

    context 'when team is notifier' do
      subject { described_class.render(team, view: :notifier) }

      it { is_expected.to include("\"link\":\"/projects/#{project.id}\"") }
    end
  end
end
