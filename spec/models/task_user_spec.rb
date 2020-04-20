# frozen_string_literal: true

# == Schema Information
#
# Table name: task_users
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  task_id    :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_task_users_on_task_id              (task_id)
#  index_task_users_on_user_id              (user_id)
#  index_task_users_on_user_id_and_task_id  (user_id,task_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (task_id => tasks.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

describe TaskUser, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:task) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:task_id) }

    describe 'UNIQUE user_id, task_id' do
      subject { build(:task_user) }

      it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:task_id) }
    end
  end
end
