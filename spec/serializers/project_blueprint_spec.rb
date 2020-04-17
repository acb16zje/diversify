# frozen_string_literal: true

require 'rails_helper'

describe ProjectBlueprint, type: :serializer do
  let(:project) { build_stubbed(:project) }

  describe 'fields' do
    subject { described_class.render(project) }

    it { is_expected.to include("\"name\":\"#{project.name}\"") }
  end

  describe 'view' do
    context 'when notifiable with default icon' do
      subject { described_class.render(project, view: :notifiable) }

      it { is_expected.to include('project-avatar') }
    end

    context 'when notifiable with avatar icon' do
      subject { described_class.render(project, view: :notifiable) }

      let(:project) { build_stubbed(:project, :with_avatar) }

      it { is_expected.to include('active_storage') }
    end

    context 'when notifier' do
      subject { described_class.render(project, view: :notifier) }

      it { is_expected.to include("\"link\":\"/projects/#{project.id}\"") }
    end
  end
end
