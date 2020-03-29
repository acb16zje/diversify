# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  description :text             default(""), not null
#  name        :string           default(""), not null
#  status      :enum             default("Active"), not null
#  visibility  :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint
#  user_id     :bigint
#
# Indexes
#
#  index_projects_on_category_id  (category_id)
#  index_projects_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

describe Project, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:category) }
    it { is_expected.to have_many(:teams) }
    it { is_expected.to have_many(:reviews) }
    it { is_expected.to have_many(:tasks) }
    it { is_expected.to have_many(:invites) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:status) }

    it 'verifies avatar datatype' do
      is_expected.to validate_content_type_of(:avatar)
        .allowing('image/png', 'image/jpg', 'image/jpeg')
    end

    it 'verifies avatar file size' do
      is_expected.to validate_size_of(:avatar)
        .less_than_or_equal_to(200.kilobytes)
    end
  end
end
