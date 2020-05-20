# frozen_string_literal: true

# == Schema Information
#
# Table name: appeals
#
#  id         :bigint           not null, primary key
#  type       :enum             default("invitation"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_appeals_on_project_id              (project_id)
#  index_appeals_on_user_id                 (user_id)
#  index_appeals_on_user_id_and_project_id  (user_id,project_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

describe Appeal, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:project) }
  end

  describe 'validations' do
    let(:invitation) { build(:invitation) }

    describe 'UNIQUE user_id, project_id' do
      subject { invitation }

      it {
        is_expected.to validate_uniqueness_of(:user_id)
          .scoped_to(:project_id)
          .with_message('has already been invited/applied')
      }
    end

    describe '#not_owner' do
      subject { invitation.valid? }

      before do
        invitation.project.user = invitation.user
        invitation.save
      end

      it { is_expected.to be_falsey }
    end

    describe '#in_project' do
      subject { invitation.valid? }

      before do
        invitation.project = create(:project)
        invitation.project.teams.first.users << invitation.user
        invitation.save
      end

      it { is_expected.to be_falsey }
    end
  end

  describe 'scopes' do
    describe '.list_in_project' do
      subject { described_class.list_in_project(appeal.project).size }

      let!(:appeal) { create(:appeal) }

      it { is_expected.to eq(1) }
    end
  end

  describe 'after_commit hook' do
    describe '#send_notification, on: :create' do
      it { expect { create(:appeal) }.to change(Notification, :count).by(1) }
    end
  end

  describe '#send_resolve_notification' do
    subject { Notification.count }

    let(:appeal) { build(:appeal) }

    context 'when canceled by initiator' do
      before { appeal.send_resolve_notification('accept', true) }

      it { is_expected.to eq(0) }
    end

    context 'when not canceled by initiator' do
      before { appeal.send_resolve_notification('decline', false) }

      it { is_expected.to eq(1) }
    end

    describe 'delete send type notification' do
      subject { Notification.first.key }

      before { create(:appeal).send_resolve_notification('accept') }

      it { is_expected.to eq('invitation/accept') }
    end
  end
end
