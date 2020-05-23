# frozen_string_literal: true

require 'rails_helper'

describe NotificationBlueprint, type: :serializer do
  subject { described_class.render(notification) }

  let(:user) { build_stubbed(:user) }
  let(:project) { build_stubbed(:project) }
  let(:notification) { build_stubbed(:notification, notifiable: user, notifier: project) }

  describe 'fields' do
    it { is_expected.to include('id') }
    it { is_expected.to include('key') }
    it { is_expected.to include('read') }
    it { is_expected.to include('time_ago') }
  end

  describe 'associations' do
    context 'when notifiable is User' do
      let(:notification) { build_stubbed(:notification, notifiable: user, notifier: project) }

      it { is_expected.to include('user-avatar-container') }
    end

    context 'when notifiable is Project' do
      let(:notification) { build_stubbed(:notification, notifiable: project, notifier: project) }

      it { is_expected.to include('project-avatar') }
    end

    context 'when notifier is Project' do
      it { is_expected.to match(%r{/projects/\d+}) }
    end

    context 'when notifier is Team' do
      let(:team) { build_stubbed(:team) }
      let(:notification) { build_stubbed(:notification, notifiable: user, notifier: team) }

      it { is_expected.to match(%r{/projects/\d+}) }
    end

    context 'when notifier is Task' do
      let(:task) { build_stubbed(:task) }
      let(:notification) { build_stubbed(:notification, notifiable: user, notifier: task) }

      it { is_expected.to match(%r{/projects/\d+}) }
    end
  end
end
