# frozen_string_literal: true

require 'rails_helper'

describe Projects::Appeals::ApplicationsController, type: :request do
  let(:user) { create(:user) }

  before { |test| sign_in user unless test.metadata[:no_sign_in] }

  describe 'authentications', :no_sign_in do
    describe 'GET #index' do
      subject(:request) { get project_applications_path(project_id: 1) }

      it_behaves_like 'not accessible to unauthenticated users'
    end

    describe 'POST  #create' do
      subject(:request) { post project_applications_path(project_id: 1) }

      it_behaves_like 'not accessible to unauthenticated users'
    end

    describe 'POST #accept' do
      subject(:request) { post accept_application_path(id: 1) }

      it_behaves_like 'not accessible to unauthenticated users'
    end

    describe 'DELETE #destroy' do
      subject(:request) { delete application_path(id: 1) }

      it_behaves_like 'not accessible to unauthenticated users'
    end
  end

  describe 'GET #index' do
    subject(:request) { get project_applications_path(project) }

    context 'when user is project owner' do
      let(:project) { create(:project, user: user) }

      it_behaves_like 'returns JSON response'
    end

    context 'when user is not project owner' do
      let(:project) { create(:project) }

      it_behaves_like 'returns 403 Forbidden'
    end
  end

  describe 'POST #create' do
    subject(:request) { post project_applications_path(project) }

    context 'when user is project owner' do
      let(:project) { create(:project, :open, user: user) }

      it_behaves_like 'returns 403 Forbidden'
    end

    context 'when user is not project owner' do
      let(:project) { create(:project, :open) }

      it_behaves_like 'returns 200 OK'
    end
  end

  describe 'POST #accept' do
    subject(:request) { post accept_application_path(application) }

    context 'when user is application owner' do
      let(:application) { create(:application, user: user) }

      it_behaves_like 'returns 403 Forbidden'
    end

    context 'when user is not application owner' do
      let(:application) { create(:application) }

      it_behaves_like 'returns 403 Forbidden'
    end

    context 'when user is project owner' do
      let(:project) { create(:project, user: user) }
      let(:application) { create(:application, project: project) }

      it_behaves_like 'returns 200 OK'
    end

    context 'when project is full' do
      let(:project) do
        create(:project_with_members, user: user, members_count: 9)
      end

      let(:application) { create(:application, project: project) }

      it_behaves_like 'returns 422 Unprocessable Entity'
    end
  end

  describe 'DELETE #destroy' do
    subject(:request) { delete application_path(application) }

    context 'when user is application owner' do
      let(:application) { create(:application, user: user) }

      it_behaves_like 'returns 200 OK'
    end

    context 'when user is not application owner' do
      let(:application) { create(:application) }

      it_behaves_like 'returns 403 Forbidden'
    end
  end
end
