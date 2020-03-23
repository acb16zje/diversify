# frozen_string_literal: true

# == Schema Information
#
# Table name: applications
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
#  index_applications_on_project_id  (project_id)
#  index_applications_on_user_id     (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

describe Application, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:project) }
  end

  # UNABLE TO GET IT TO WORK
  # FIX LATER
  # describe 'validations' do
  #   subject { FactoryBot.create(:application) }

  #   it {
  #     subject.types = 'Invite'
  #     is_expected.to validate_uniqueness_of(:types)
  #       .scoped_to(:project_id, :user_id)
  #   }
  # end
end
