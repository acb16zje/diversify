# frozen_string_literal: true

require 'rails_helper'

describe Projects::Teams::TeamsController, type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }

  let(:project) { create(:project) }
  let(:team) { create(:team, project: project) }

  describe 'authorisations' do
    before { sign_in user }

    describe '#new' do
      subject(:request) { get new_project_team_path(project) }

      it { expect { request }.to be_authorized_to(:manage?, project) }
    end

    describe '#edit' do
      subject(:request) do
        get edit_project_team_path(team, project_id: project.id)
      end

      it { expect { request }.to be_authorized_to(:access_team?, team) }
    end

    describe '#show' do
      subject(:request) do
        get project_team_path(team, project_id: project.id), xhr: true
      end

      it { expect { request }.to be_authorized_to(:show?, team) }
    end

    describe '#create' do
      subject(:request) { post project_teams_path(project) }

      it { expect { request }.to be_authorized_to(:manage?, project) }
    end

    describe '#update' do
      subject(:request) do
        patch project_team_path(team, project_id: project.id)
      end

      it { expect { request }.to be_authorized_to(:access_team?, team) }
    end

    describe '#destroy' do
      subject(:request) do
        delete project_team_path(team, project_id: project.id)
      end

      it { expect { request }.to be_authorized_to(:manage?, team) }
    end
  end


  describe 'GET #new' do
    subject(:request) { get new_project_team_path(project) }

    before { create(:skill, category: project.category) }

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

  describe 'GET #edit' do
    subject(:request) { get edit_project_team_path(project, team) }

    before { create(:skill, category: project.category) }

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

  describe 'GET #show' do
    subject(:request) { get project_team_path(project, team), xhr: true }

    context 'when not logged in' do
      it_behaves_like 'returns 200 OK'
    end

    context 'when project is private' do
      let(:project) { create(:project, :private) }

      it_behaves_like 'returns 404 Not Found'
    end

    context 'when not authorized to manage project' do
      it_behaves_like 'accessible to authenticated users'
    end

    context 'when user is admin' do
      it_behaves_like 'accessible to admin users'
    end

    context 'when user is project owner' do
      let(:project) { create(:project, user: user) }

      it_behaves_like 'accessible to authenticated users'
    end
  end

  describe 'POST #create' do
    subject(:request) { post project_teams_path(project, params) }

    let(:params) do
      { team: {
        name: 'Test', team_size: 1, project_id: project.id, skills_ids: []
      } }
    end

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

    context 'when input is invalid' do
      let(:params) do
        { team: {
          name: 'Test', team_size: -1, project_id: project.id, skills_ids: []
        } }
      end

      before { sign_in admin }

      it_behaves_like 'returns 422 Unprocessable Entity'
    end

    context 'when team has skill' do
      let(:skill) { create(:skill, category: project.category) }
      let(:params) do
        { team: {
          name: 'Test', team_size: 1, project_id: project.id,
          skills_ids: [skill.id]
        } }
      end

      it_behaves_like 'accessible to admin users'
    end
  end

  describe 'PATCH #update' do
    subject(:request) { patch project_team_path(project, team, params) }

    let(:params) do
      { team: {
        name: 'Test', team_size: 1, project_id: project.id, skills_ids: []
      } }
    end

    context 'when not authorized to manage project' do
      it_behaves_like 'not accessible to unauthorised users for private object'
    end

    context 'when user is admin' do
      it_behaves_like 'accessible to admin users'
    end

    context 'when user is project owner' do
      let(:project) { create(:project, user: user) }

      it_behaves_like 'accessible to authenticated users'
    end

    context 'when input is invalid' do
      let(:params) do
        { team: {
          name: 'Test', team_size: -1, project_id: project.id, skills_ids: []
        } }
      end

      before { sign_in admin }

      it_behaves_like 'returns 422 Unprocessable Entity'
    end

    context 'when team has skill' do
      let(:skill) { create(:skill) }
      let(:params) do
        { team: {
          name: 'Test', team_size: 1, project_id: project.id,
          skills_ids: [skill.id]
        } }
      end

      it_behaves_like 'accessible to admin users'
    end
  end

  describe 'DELETE #destroy' do
    subject(:request) { delete project_team_path(project, team) }

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
end
