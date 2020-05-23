# frozen_string_literal: true

require 'rails_helper'

describe Projects::Appeals::InvitationsController, type: :request do
  let(:user) { create(:user) }

  before { |test| sign_in user unless test.metadata[:no_sign_in] }

  describe 'authentications', :no_sign_in do
    describe 'GET #index' do
      subject(:request) { get project_invitations_path(project_id: 1) }

      it_behaves_like 'not accessible to unauthenticated users'
    end

    describe 'POST  #create' do
      subject(:request) { post project_invitations_path(project_id: 1) }

      it_behaves_like 'not accessible to unauthenticated users'
    end

    describe 'POST #accept' do
      subject(:request) { post accept_invitation_path(id: 1) }

      it_behaves_like 'not accessible to unauthenticated users'
    end

    describe 'DELETE #destroy' do
      subject(:request) { delete invitation_path(id: 1) }

      it_behaves_like 'not accessible to unauthenticated users'
    end
  end

  describe 'GET #index' do
    subject(:request) { get project_invitations_path(project) }

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
    subject(:request) { post project_invitations_path(project, email: email) }

    context 'when user-to-invite is project owner' do
      let(:email) { user.email }
      let(:project) { create(:project, user: user) }

      it_behaves_like 'returns 422 Unprocessable Entity'
    end

    context 'when user-to-invite is other, user is not project owner' do
      let(:email) { create(:user).email }
      let(:project) { create(:project) }

      it_behaves_like 'returns 403 Forbidden'
    end

    context 'when user-to-invite is other, user is project owner' do
      let(:email) { create(:user).email }
      let(:project) { create(:project, user: user) }

      it_behaves_like 'returns 200 OK'
    end
  end

  describe 'POST #accept' do
    subject(:request) { post accept_invitation_path(invitation) }

    context 'when user is invitation owner' do
      let(:project) { create(:project, user: create(:user)) }
      let(:invitation) { create(:invitation, project: project, user: user) }

      it_behaves_like 'returns 200 OK'
    end

    context 'when user is not invitation owner' do
      let(:invitation) { create(:invitation) }

      it_behaves_like 'returns 403 Forbidden'
    end

    context 'when user is project owner' do
      let(:project) { create(:project, user: user) }
      let(:invitation) { create(:invitation, project: project) }

      it_behaves_like 'returns 403 Forbidden'
    end

    context 'when project is full' do
      let(:project) { create(:project_with_members, user: create(:user), members_count: 9) }

      let(:invitation) { create(:invitation, project: project, user: user) }

      it_behaves_like 'returns 422 Unprocessable Entity'
    end
  end

  describe 'DELETE #destroy' do
    subject(:request) { delete invitation_path(invitation) }

    context 'when user is invitation owner' do
      let(:invitation) { create(:invitation, user: user) }

      it_behaves_like 'returns 200 OK'
    end

    context 'when user is project owner' do
      let(:invitation) { create(:invitation, project: create(:project, user: user)) }

      it_behaves_like 'returns 200 OK'
    end

    context 'when user is not invitation owner' do
      let(:invitation) { create(:invitation) }

      it_behaves_like 'returns 403 Forbidden'
    end

    context 'when user is not project owner' do
      let(:invitation) { create(:invitation, project: create(:project)) }

      it_behaves_like 'returns 403 Forbidden'
    end
  end
end
