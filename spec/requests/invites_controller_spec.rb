# frozen_string_literal: true

require 'rails_helper'

describe InvitesController, type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project) }

  describe 'POST #create' do
    subject(:request) { post invites_path, params: params }

    context 'when application with valid input' do
      let(:params) do
        { user_id: user.email, project_id: project.id, types: 'application' }
      end

      before do
        project.visibility = true
        project.status = 'open'
        project.save
      end

      it_behaves_like 'accessible to authenticated users'
      it_behaves_like 'not accessible to unauthenticated users'
    end

    context 'when invite with valid input' do
      let(:owned_project) { create(:project, user: user) }
      let(:user2) { create(:user, email: 'notsame@email.com') }
      let(:params) do
        { user_id: user2.email, project_id: owned_project.id, types: 'invite' }
      end

      it_behaves_like 'accessible to authenticated users'
      it_behaves_like 'not accessible to unauthenticated users'
    end

    context 'with invalid input' do
      let(:params) do
        { user_id: user.email, project_id: project.id, types: '' }
      end

      before { sign_in user }

      it_behaves_like 'returns 400 Bad Request'
    end

    context 'when not application owner' do
      let(:user2) { create(:user, email: 'notsame@email.com') }
      let(:params) do
        { user_id: user2.email, project_id: project.id, types: 'application' }
      end

      before { sign_in user }

      it_behaves_like 'returns 400 Bad Request'
    end

    context 'when not project owner' do
      let(:user2) { create(:user, email: 'notsame@email.com') }
      let(:params) do
        { user_id: user2.email, project_id: project.id, types: 'invite' }
      end

      before { sign_in user }

      it_behaves_like 'returns 400 Bad Request'
    end
  end

  describe 'DELETE #destroy' do
    subject(:request) { delete invite_path(object), params: params }

    let(:invite) { create(:invite) }
    let(:application) { create(:application) }

    context 'when application with valid input' do
      let(:object) { application }
      let(:params) { { types: 'application' } }

      before do
        application.user = user
        application.save
      end

      it_behaves_like 'accessible to authenticated users'
      it_behaves_like 'not accessible to unauthenticated users'
    end

    context 'when invite with valid input' do
      let(:object) { invite }
      let(:params) { { types: 'invite' } }

      before do
        invite.user = user
        invite.save
      end

      it_behaves_like 'accessible to authenticated users'
      it_behaves_like 'not accessible to unauthenticated users'
    end

    context 'when user is admin' do
      let(:object) { invite }
      let(:params) { { types: 'invite' } }

      before do
        user.admin = true
        user.save
      end

      it_behaves_like 'accessible to authenticated users'
      it_behaves_like 'not accessible to unauthenticated users'
    end

    context 'with invalid input' do
      let(:object) { application }
      let(:params) { { id: 'a', types: '' } }

      before { sign_in user }

      it_behaves_like 'returns 422 Unprocessable Entity'
    end

    context 'when not application owner' do
      let(:object) { application }
      let(:user2) { create(:user, email: 'notsame@email.com') }
      let(:params) { { types: 'application' } }

      before { sign_in user2 }

      it_behaves_like 'returns 400 Bad Request'
    end

    context 'when not project owner' do
      let(:object) { invite }
      let(:user2) { create(:user, email: 'notsame@email.com') }
      let(:params) do
        { types: 'invite' }
      end

      before { sign_in user2 }

      it_behaves_like 'returns 400 Bad Request'
    end
  end

  describe 'POST #accept' do
    subject(:request) { post accept_invites_path, params: params }

    let(:invite) { create(:invite, user: user) }
    let(:application) { create(:application) }

    context 'when application with valid input' do
      let(:params) do
        { id: application.id, types: 'application' }
      end

      before { user.admin = true }

      it_behaves_like 'accessible to authenticated users'
      it_behaves_like 'not accessible to unauthenticated users'
    end

    context 'when invite with valid input' do
      let(:params) do
        { id: invite.id, types: 'invite' }
      end

      it_behaves_like 'accessible to authenticated users'
      it_behaves_like 'not accessible to unauthenticated users'
    end

    context 'with invalid input' do
      let(:params) do
        { id: 'a', types: '' }
      end

      before { sign_in user }

      it_behaves_like 'returns 422 Unprocessable Entity'
    end

    context 'when not application owner' do
      let(:user2) { create(:user, email: 'notsame@email.com') }
      let(:params) do
        { id: application.id, types: 'application' }
      end

      before { sign_in user2 }

      it_behaves_like 'returns 400 Bad Request'
    end

    context 'when not project owner' do
      let(:user2) { create(:user, email: 'notsame@email.com') }
      let(:params) do
        { id: invite.id, types: 'invite' }
      end

      before { sign_in user2 }

      it_behaves_like 'returns 400 Bad Request'
    end

    context 'when target is already in team' do
      let(:params) { { id: invite.id, types: 'invite' } }

      before do
        team = invite.project.teams.first
        team.users << invite.user
        team.save
        sign_in user
      end

      it_behaves_like 'returns 422 Unprocessable Entity'
    end
  end
end
