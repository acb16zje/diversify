# frozen_string_literal: true

require 'rails_helper'

describe AvatarHelper, type: :helper do

  describe '#user_avatar' do
    subject { user_avatar(user) }

    context 'without avatar' do
      let(:user) { build_stubbed(:user) }

      it { is_expected.to include(Digest::MD5.hexdigest(user.email)) }
    end

    context 'with avatar' do
      let(:user) { build_stubbed(:user, :with_avatar) }

      it { is_expected.to be_an_instance_of(ActiveStorage::Variant) }
    end
  end

  describe '#project_icon' do
    subject { project_icon(project) }

    context 'without avatar' do
      let(:project) { build_stubbed(:project) }

      it { is_expected.to match(%r{<div class="identicon bg\d+">[A-Z]+</div>}) }
    end

    context 'with avatar' do
      let(:project) { build_stubbed(:project, :with_avatar) }

      it { is_expected.to match(%r{.+<img src=".+squirtle\.png" />.+}) }
    end
  end
end
