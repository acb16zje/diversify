# frozen_string_literal: true

require 'rails_helper'

describe InvitesController, type: :request do
  let(:user) { create(:user) }
  let(:project) { create(:project) }

  describe 'POST #create' do
    subject(:request) { post invites_path, params: params }

    context 'when application with valid input' do
      let(:params) do
        { user_id: user.email, project_id: project.id, types: 'Application' }
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
        { user_id: user2.email, project_id: owned_project.id, types: 'Invite' }
      end

      it_behaves_like 'accessible to authenticated users'
      it_behaves_like 'not accessible to unauthenticated users'
    end

    context 'with invalid input' do
      let (:params) do
        { user_id: user.email, project_id: project.id, types: '' }
      end

      before { sign_in user }

      it_behaves_like 'returns 400 Bad Request'
    end

    context 'when not application owner' do
      let(:user2) { create(:user, email: 'notsame@email.com') }
      let(:params) do
        { user_id: user2.email, project_id: project.id, types: 'Application' }
      end

      before { sign_in user }

      it_behaves_like 'returns 400 Bad Request'
    end

    context 'when not project owner' do
      let(:user2) { create(:user, email: 'notsame@email.com') }
      let(:params) do
        { user_id: user2.email, project_id: project.id, types: 'Invite' }
      end

      before { sign_in user }

      it_behaves_like 'returns 400 Bad Request'
    end
  end

  describe 'DELETE #destroy' do
    subject(:request) { delete invite_path(object), params: params }

    let(:invite) { create(:invite, user: user) }
    let(:application) { create(:application, user: user) }

    context 'when application with valid input' do
      let(:object) { application }
      let(:params) do
        { types: 'Application' }
      end

      it_behaves_like 'accessible to authenticated users'
      it_behaves_like 'not accessible to unauthenticated users'
    end

    context 'when invite with valid input' do
      let(:object) { invite }
      let(:params) do
        { types: 'Invite' }
      end

      before { user.admin = true }

      it_behaves_like 'accessible to authenticated users'
      it_behaves_like 'not accessible to unauthenticated users'
    end

    context 'with invalid input' do
      let(:object) { application }
      let(:params) do
        { id: 'a', types: '' }
      end

      before { sign_in user }

      it_behaves_like 'returns 422 Unprocessable Entity'
    end

    context 'when not application owner' do
      let(:object) { application }
      let(:user2) { create(:user, email: 'notsame@email.com') }
      let(:params) do
        { types: 'Application' }
      end

      before { sign_in user2 }

      it_behaves_like 'returns 400 Bad Request'
    end

    context 'when not project owner' do
      let(:object) { invite }
      let(:user2) { create(:user, email: 'notsame@email.com') }
      let(:params) do
        { types: 'Invite' }
      end

      before { sign_in user2 }

      it_behaves_like 'returns 400 Bad Request'
    end
  end

  # describe 'POST #accept' do
  #   subject(:request) { post accept_invites_path, params: params }

  #   let(:invite) { create(:invite, user: user) }
  #   let(:application) { create(:application) }

  #   context 'when application with valid input' do
  #     let(:params) do
  #       { id: application.id, types: 'Application' }
  #     end

  #     before { user.admin = true }

  #     it_behaves_like 'accessible to authenticated users'
  #     it_behaves_like 'not accessible to unauthenticated users'
  #   end

  #   context 'when invite with valid input' do
  #     let(:params) do
  #       { id: invite.id, types: 'Invite' }
  #     end

  #     it_behaves_like 'accessible to authenticated users'
  #     it_behaves_like 'not accessible to unauthenticated users'
  #   end

  #   context 'with invalid input' do
  #     let(:params) do
  #       { id: 'a', types: '' }
  #     end

  #     before { sign_in user }

  #     it_behaves_like 'returns 422 Unprocessable Entity'
  #   end

  #   context 'when not application owner' do
  #     let(:user2) { create(:user, email: 'notsame@email.com') }
  #     let(:params) do
  #       { id: application.id, types: 'Application' }
  #     end

  #     before { sign_in user2 }

  #     it_behaves_like 'returns 400 Bad Request'
  #   end

  #   context 'when not project owner' do
  #     let(:user2) { create(:user, email: 'notsame@email.com') }
  #     let(:params) do
  #       { id: invite.id, types: 'Invite' }
  #     end

  #     before { sign_in user2 }

  #     it_behaves_like 'returns 400 Bad Request'
  #   end
  # end
end
