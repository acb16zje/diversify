# frozen_string_literal: true

require 'rails_helper'

describe Projects::Teams::ManageController, type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }

  let(:project) { create(:project) }
  let(:team) { create(:team, :with_skill, project: project) }

  before do
    team
    personality = create(:personality, :intj)
    personality2 = create(:personality, :isfp)
    perfect = create(:user, :with_skill)
    perfect.personality = personality
    skill_only = create(:user, :with_skill)
    personality_only = create(:user)
    personality_only.personality = personality2

    project.unassigned_team.users << [perfect, skill_only, personality_only]
  end

  describe 'authorisations' do
    before { sign_in user }

    describe '#index' do
      subject(:request) { get project_manage_index_path(project) }

      it { expect { request }.to be_authorized_to(:manage?, project) }
    end

    describe '#manage_data' do
      subject(:request) { get manage_data_project_manage_index_path(project) }

      it { expect { request }.to be_authorized_to(:manage?, project) }
    end

    describe '#suggest' do
      subject(:request) do
        get suggest_project_manage_index_path(project, params)
      end

      let(:params) { { mode: 'balance' } }

      it { expect { request }.to be_authorized_to(:manage?, project) }
    end

    describe '#create' do
      subject(:request) { post project_manage_index_path(project) }

      it { expect { request }.to be_authorized_to(:manage?, project) }
    end

    describe '#recompute_data' do
      subject(:request) do
        post recompute_data_project_manage_index_path(project, params)
      end

      let(:params) { { mode: 'balance' } }

      it { expect { request }.to be_authorized_to(:manage?, project) }
    end

    describe '#remove_user' do
      subject(:request) do
        delete remove_user_project_manage_index_path(project_id: project.id)
      end

      it { expect { request }.to be_authorized_to(:manage?, project) }
    end
  end

  describe 'GET #index' do
    subject(:request) { get project_manage_index_path(project) }

    context 'when not authorized to manage project' do
      it_behaves_like 'not accessible to unauthorised users for private object'
    end

    context 'when user is admin' do
      it_behaves_like 'accessible to admin users'
      it_behaves_like 'not accessible to non-admin users'
    end

    context 'when user is project owner' do
      let(:project) { create(:project, user: user) }

      it_behaves_like 'accessible to authenticated users'
    end
  end

  describe 'GET #manage_data' do
    subject(:request) do
      get manage_data_project_manage_index_path(project), xhr: true
    end

    context 'when not logged in' do
      it_behaves_like 'returns 401 Unauthorized'
    end

    context 'when not authorized to manage project' do
      before { sign_in user }

      it_behaves_like 'returns 404 Not Found'
    end

    context 'when user is admin' do
      it_behaves_like 'accessible to admin users'
    end

    context 'when user is project owner' do
      let(:project) { create(:project, user: user) }

      it_behaves_like 'accessible to authenticated users'
    end
  end

  describe 'GET #suggest' do
    subject(:request) do
      get suggest_project_manage_index_path(project, params), xhr: true
    end

    let(:params) { { mode: 'balance' } }

    context 'when not logged in' do
      it_behaves_like 'returns 401 Unauthorized'
    end

    context 'when not authorized to manage project' do
      before { sign_in user }

      it_behaves_like 'returns 404 Not Found'
    end

    context 'when user is admin' do
      it_behaves_like 'accessible to admin users'
    end

    context 'when user is project owner' do
      let(:project) { create(:project, user: user) }

      it_behaves_like 'accessible to authenticated users'
    end

    context 'when invalid mode' do
      let(:params) { { mode: '' } }

      before { sign_in user }

      it_behaves_like 'returns 404 Not Found'
    end
  end

  describe 'POST #create' do
    subject(:request) do
      post project_manage_index_path(project, params), xhr: true
    end

    let(:params) do
      { data:
          "{\"#{team.id}\":[{\"id\":#{user.id},\"team_id\":#{team.id}}]
          ,\"#{team2.id}\":[{\"id\":#{user2.id},\"team_id\":#{team.id}}]}" }
    end

    let(:user2) { create(:user) }
    let(:team2) { create(:team, project: project) }

    context 'when not logged in' do
      it_behaves_like 'returns 401 Unauthorized'
    end

    context 'when not authorized to manage project' do
      before { sign_in user }

      it_behaves_like 'returns 404 Not Found'
    end

    context 'when user is admin' do
      before do
        project.unassigned_team.users << user
        project.unassigned_team.users << user2
      end

      it_behaves_like 'accessible to admin users'
    end

    context 'when user is project owner' do
      let(:project) { create(:project, user: user) }

      before { project.unassigned_team.users << user2 }

      it_behaves_like 'accessible to authenticated users'
    end

    context 'when unauthorized team' do
      let(:project) { create(:project, user: user) }
      let(:team2) { create(:team) }

      before { sign_in user }

      it { expect(team2.users.size).to eq(0) }
    end
  end

  describe 'POST #recompute_data' do
    subject(:request) do
      post recompute_data_project_manage_index_path(project, params), xhr: true
    end

    let(:params) do
      { mode: 'balance',
        data:
          "{\"#{team.id}\":[{\"id\":#{user.id},\"team_id\":#{team.id}}]
          ,\"#{team2.id}\":[{\"id\":#{user2.id},\"team_id\":#{team.id}}]}" }
    end

    let(:user2) { create(:user) }
    let(:team2) { create(:team, project: project) }

    context 'when not logged in' do
      it_behaves_like 'returns 401 Unauthorized'
    end

    context 'when not authorized to manage project' do
      before { sign_in user }

      it_behaves_like 'returns 404 Not Found'
    end

    context 'when user is admin' do
      it_behaves_like 'accessible to admin users'
    end

    context 'when user is project owner' do
      let(:project) { create(:project, user: user) }

      it_behaves_like 'accessible to authenticated users'
    end

    context 'when invalid mode' do
      let(:params) { { mode: '' } }

      before { sign_in user }

      it_behaves_like 'returns 404 Not Found'
    end
  end

  describe 'DELETE #remove_user' do
    subject(:request) do
      delete remove_user_project_manage_index_path(project, params)
    end

    let(:target) { create(:user) }
    let(:params) { { user_id: target.id } }

    before { project.unassigned_team.users << target }

    context 'when not authorized to manage project' do
      it_behaves_like 'not accessible to unauthorised users for private object'
    end

    context 'when user is admin' do
      it_behaves_like 'accessible to admin users'
      it_behaves_like 'not accessible to non-admin users'
    end

    context 'when user is project owner' do
      let(:project) { create(:project, user: user) }

      it_behaves_like 'accessible to authenticated users'
    end

    context 'when target user is project owner' do
      let(:params) { { user_id: project.user.id } }

      before { sign_in admin }

      it_behaves_like 'returns 422 Unprocessable Entity'
    end
  end
end
