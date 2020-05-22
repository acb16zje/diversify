# frozen_string_literal: true

require 'rails_helper'

describe Users::Settings::SkillsController, type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe 'GET #show' do
    subject(:request) { get settings_skills_path }

    it_behaves_like 'returns 200 OK'
  end

  describe 'POST #create' do
    subject(:request) { post settings_skills_path(params) }

    context 'when adding skills that are not added to profile yet' do
      let(:params) { { skill: { skill_ids: [create(:skill).id] } } }

      it_behaves_like 'returns 200 OK'
    end

    context 'when adding skills that are already added to profile' do
      let!(:user_skill) { create(:user_skill, user: user) }
      let(:params) { { skill: { skill_ids: [user_skill.skill_id] } } }

      it_behaves_like 'returns 422 Unprocessable Entity'
    end
  end

  describe 'DELETE #destroy' do
    subject(:request) { delete settings_skills_path(skill_id: skill_id) }

    context 'with valid id' do
      let(:skill_id) { create(:user_skill, user: user).skill_id }

      it_behaves_like 'returns 200 OK'
    end

    context 'with non-existent id' do
      let(:skill_id) { -1 }

      it_behaves_like 'returns 404 Not Found'
    end
  end
end
