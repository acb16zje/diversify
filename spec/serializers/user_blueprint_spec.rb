# frozen_string_literal: true

require 'rails_helper'

describe UserBlueprint, type: :serializer do
  let(:user) { build_stubbed(:user) }

  describe 'fields' do
    subject { described_class.render(user) }

    it { is_expected.to include("\"name\":\"#{user.name}\"") }
  end

  describe 'view' do
    context 'when notifiable with default icon' do
      subject { described_class.render(user, view: :notifiable) }

      it { is_expected.to include('user-avatar-container') }
    end

    context 'when notifiable with avatar icon' do
      subject { described_class.render(user, view: :notifiable) }

      let(:user) { build_stubbed(:user, :with_avatar) }

      it { is_expected.to include('active_storage') }
    end
  end
end
