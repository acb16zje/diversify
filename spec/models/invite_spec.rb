# frozen_string_literal: true

# == Schema Information
#
# Table name: invites
#
#  id         :bigint           not null, primary key
#  types      :enum             default("Invite"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_invites_on_project_id  (project_id)
#  index_invites_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

describe Invite, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:project) }
  end

  describe 'validations' do
    let(:invite) { build(:invite) }

    context 'when validate uniqueness of user and project' do

      it {
        expect(invite).to validate_uniqueness_of(:user_id)
          .scoped_to(:project_id).with_message(
            'has already been invited/applied'
          )
      }
    end

    context 'when validate user is not project owner' do
      before do
        invite.project.user = invite.user
        invite.save
      end

      it { expect(invite.errors.full_messages).to include('Owner cannot be added to project') }
    end
  end
end
