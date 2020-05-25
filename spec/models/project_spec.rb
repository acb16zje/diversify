# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id          :bigint           not null, primary key
#  description :text             default(""), not null
#  name        :string(100)      default(""), not null
#  status      :enum             default("active"), not null
#  visibility  :boolean          default(TRUE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  category_id :bigint
#  user_id     :bigint           not null
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

    it { is_expected.to have_one(:avatar_attachment) }

    it { is_expected.to have_many(:appeals) }
    it { is_expected.to have_many(:notifications) }
    it { is_expected.to have_many(:tasks) }
    it { is_expected.to have_many(:teams) }
    it { is_expected.to have_many(:users).through(:teams) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }

    it {
      is_expected
        .to validate_content_type_of(:avatar)
        .allowing('image/png', 'image/jpg', 'image/jpeg')
    }

    it { is_expected.to validate_size_of(:avatar).less_than_or_equal_to(200.kilobytes) }
  end

  describe 'scopes' do
    describe '.search' do
      subject { described_class.search(params) }

      let(:params) { { name: 'diversify' } }
      let!(:project) { create(:project, name: 'diversify') }

      it { is_expected.to match_array([project]) }
    end
  end

  describe 'before_validation hook' do
    describe '#validate_status_update' do
      let(:project) { create(:project_with_members, user: create(:user), members_count: 9) }

      before do
        project.reload # otherwise project.users won't be updated
        project.status = 'open'
      end

      it { expect(project.save).to be_falsey }
    end
  end

  describe 'before_save hook' do
    describe '#validate_visibility_change' do
      let(:project) { build(:project, user: user) }

      before { project.visibility = false }

      # rubocop:disable RSpec/NestedGroups
      context 'when free user' do
        let(:user) { create(:user) }

        it { expect(project.save).to be_falsey }
      end

      context 'when pro user' do
        let(:user) { create(:user, :pro) }

        it { expect(project.save).to be_truthy }
      end

      context 'when ultimate user' do
        let(:user) { create(:user, :ultimate) }

        it { expect(project.save).to be_truthy }
      end
      # rubocop:enable RSpec/NestedGroups
    end
  end

  describe '#applicable?' do
    subject { project.applicable? }

    context 'when private' do
      let(:project) { build_stubbed(:project, :private) }

      it { is_expected.to be_falsey }
    end

    context 'when active and public' do
      let(:project) { build_stubbed(:project) }

      it { is_expected.to be_falsey }
    end

    context 'when completed and public' do
      let(:project) { build_stubbed(:project, :completed) }

      it { is_expected.to be_falsey }
    end

    context 'when open and public' do
      let(:project) { build_stubbed(:project, :open) }

      it { is_expected.to be_truthy }
    end
  end

  describe '#assigned_team' do
    subject { project.unassigned_team.name }

    let(:project) { create(:project) }

    it { is_expected.to eq('Unassigned') }
  end
end
