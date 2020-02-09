# frozen_string_literal: true

require 'rails_helper'

describe AvatarHelper, type: :helper do
  let(:gravatar_user) { build_stubbed(:user) }
  let(:avatar_user) { build_stubbed(:user, :with_avatar) }

  describe '#user_avatar' do

    context 'without avatar'  do
      subject { user_avatar(gravatar_user) }

      it { is_expected.to include(Digest::MD5.hexdigest(gravatar_user.email)) }
    end

    context 'with avatar' do
      subject { user_avatar(avatar_user) }

      it { is_expected.to be_an_instance_of(ActiveStorage::Variant) }
    end
  end
end
