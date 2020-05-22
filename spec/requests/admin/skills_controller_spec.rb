# frozen_string_literal: true

require 'rails_helper'

describe Admin::SkillsController, type: :request do
  let(:admin) { create(:admin) }
  let(:skill) { create(:skill) }

  before { sign_in admin }

  describe 'GET #index' do
    subject(:request) { get admin_skills_path }

    it_behaves_like 'returns 200 OK'
  end

  describe 'POST #create' do
    subject(:request) { post admin_skills_path(params) }

    let(:category_id) { skill.category.id }

    context 'with new name' do
      let(:params) { { skill: { name: 'newname', category_id: category_id } } }

      it_behaves_like 'returns 200 OK'
    end

    context 'without category selected' do
      let(:params) { { skill: { name: 'newname' } } }

      it_behaves_like 'returns 422 Unprocessable Entity'
    end

    context 'with duplicate name' do
      let(:params) do
        { skill: { name: skill.name, category_id: category_id } }
      end

      it_behaves_like 'returns 422 Unprocessable Entity'
    end
  end

  describe 'PATCH #update' do
    subject(:request) { patch admin_skill_path(skill, params) }

    context 'with new name' do
      let(:params) { { skill: { name: 'newname' } } }

      it_behaves_like 'returns 200 OK'
    end

    context 'without changes' do
      let(:params) { { skill: { name: skill.name } } }

      it_behaves_like 'returns 200 OK'
    end

    context 'with duplicate name' do
      let(:skill2) { create(:skill) }
      let(:params) { { skill: { name: skill2.name } } }

      it_behaves_like 'returns 422 Unprocessable Entity'
    end
  end

  describe 'DELETE #destroy' do
    subject(:request) { delete admin_skill_path(skill) }

    it_behaves_like 'returns 200 OK'
  end
end
