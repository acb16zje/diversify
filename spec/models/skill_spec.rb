# frozen_string_literal: true

# == Schema Information
#
# Table name: skills
#
#  id          :bigint           not null, primary key
#  name        :string           default(""), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint
#
# Indexes
#
#  index_skills_on_category_id  (category_id)
#  index_skills_on_name         (name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (category_id => categories.id)
#
require 'rails_helper'

describe Skill, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:category) }

    it { is_expected.to have_many(:task_skills).dependent(:destroy) }
    it { is_expected.to have_many(:tasks).through(:task_skills) }

    it { is_expected.to have_many(:team_skills).dependent(:destroy) }
    it { is_expected.to have_many(:teams).through(:team_skills) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end
end
