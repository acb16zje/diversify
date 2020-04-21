# frozen_string_literal: true

require 'rails_helper'

describe Projects::TasksController, type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }

  describe 'authorisations' do
    let(:project) { create(:project, user: user) }
    let(:task) { create(:task, project: project) }

    before { sign_in user }

    describe '#new' do
      subject(:request) { get new_project_task_path(project) }

      it { expect { request }.to be_authorized_to(:create_task?, project) }
    end

    describe '#edit' do
      subject(:request) { get edit_project_task_path(task, project_id: project.id) }

      it { expect { request }.to be_authorized_to(:manage?, task) }
    end

    describe '#create' do
      subject(:request) { post project_tasks_path(project) }

      it { expect { request }.to be_authorized_to(:create_task?, project) }
    end

    describe '#update' do
      subject(:request) { put project_task_path(task, project_id: project.id) }

      it { expect { request }.to be_authorized_to(:manage?, task) }
    end

    describe '#destroy' do
      subject(:request) do
        delete project_task_path(task, project_id: project.id)
      end

      it { expect { request }.to be_authorized_to(:manage?, task) }
    end

    describe '#data' do
      subject(:request) { get data_project_tasks_path(project), xhr: true }

      it { expect { request }.to be_authorized_to(:count?, project) }
    end

    describe '#set_percentage' do
      subject(:request) do
        patch set_percentage_project_task_path(task, project_id: project)
      end

      it { expect { request }.to be_authorized_to(:set_percentage?, task) }
    end
  end

  describe 'GET #new' do
    subject(:request) { get new_project_task_path(project) }

    let(:project) { create(:project) }
    let(:team) { create(:team, project: project) }
    let(:task) { create(:task, project: project) }

    before { create(:skill, category: project.category) }

    context 'when not logged in' do
      it_behaves_like 'not accessible to unauthenticated users'
    end

    context 'when not in project' do
      before { sign_in user }

      it_behaves_like 'returns 404 Not Found'
    end

    context 'when not assigned team' do
      before do
        project.unassigned_team.users << user
        sign_in user
      end

      it_behaves_like 'returns 404 Not Found'
    end

    context 'when assigned team' do
      before { team.users << user }

      it_behaves_like 'accessible to authenticated users'
    end

    context 'when project owner' do
      let(:project) { create(:project, user: user) }

      it_behaves_like 'accessible to authenticated users'
    end

    context 'when admin' do
      it_behaves_like 'accessible to admin users'
    end
  end

  describe 'GET #edit' do
    subject(:request) { get edit_project_task_path(task, project_id: project.id) }

    let(:project) { create(:project) }
    let(:team) { create(:team, project: project) }
    let(:task) { create(:task, project: project) }

    before { create(:skill, category: project.category) }

    context 'when not logged in' do
      it_behaves_like 'not accessible to unauthenticated users'
    end

    context 'when not in project' do
      before { sign_in user }

      it_behaves_like 'returns 404 Not Found'
    end

    context 'when not task owner' do
      before do
        project.unassigned_team.users << user
        sign_in user
      end

      it_behaves_like 'returns 404 Not Found'
    end

    context 'when task owner' do
      let(:task) { create(:task, project: project, user: user) }

      it_behaves_like 'accessible to authenticated users'
    end

    context 'when project owner' do
      let(:project) { create(:project, user: user) }

      it_behaves_like 'accessible to authenticated users'
    end

    context 'when admin' do
      it_behaves_like 'accessible to admin users'
    end
  end

  describe 'POST #create' do
    subject(:request) { post project_tasks_path(project), params: params }

    let(:project) { create(:project) }
    let(:team) { create(:team, project: project) }
    let(:task) { create(:task, project: project) }
    let(:params) do
      { task: {
        name: 'Test', project_id: project.id, user_id: user.id
      } }
    end

    context 'when not logged in' do
      it_behaves_like 'not accessible to unauthenticated users'
    end

    context 'when not in project' do
      before { sign_in user }

      it_behaves_like 'returns 404 Not Found'
    end

    context 'when invalid input' do
      let(:params) do
        { task: {
          name: '', project_id: project.id, user_id: user.id
        } }
      end

      before { sign_in admin }

      it_behaves_like 'returns 422 Unprocessable Entity'
    end

    context 'when not assigned team' do
      before do
        project.unassigned_team.users << user
        sign_in user
      end

      it_behaves_like 'returns 404 Not Found'
    end

    context 'when assigned team' do
      before { team.users << user }

      it_behaves_like 'accessible to authenticated users'
    end

    context 'when project owner' do
      let(:project) { create(:project, user: user) }

      it_behaves_like 'accessible to authenticated users'
    end

    context 'when admin' do
      it_behaves_like 'accessible to admin users'
    end
  end

  describe 'PATCH #update' do
    subject(:request) do
      patch project_task_path(task, project_id: project), params: params
    end

    let(:project) { create(:project) }
    let(:team) { create(:team, project: project) }
    let(:task) { create(:task, project: project) }

    let(:params) do
      { task: {
        name: 'Test', project_id: project.id, user_id: user.id
      } }
    end

    context 'when not logged in' do
      it_behaves_like 'not accessible to unauthenticated users'
    end

    context 'when not in project' do
      before { sign_in user }

      it_behaves_like 'returns 404 Not Found'
    end

    context 'when invalid input' do
      let(:params) do
        { task: {
          name: '', project_id: project.id, user_id: user.id
        } }
      end

      before { sign_in admin }

      it_behaves_like 'returns 422 Unprocessable Entity'
    end

    context 'when not task owner' do
      before do
        project.unassigned_team.users << user
        sign_in user
      end

      it_behaves_like 'returns 404 Not Found'
    end

    context 'when task owner' do
      let(:task) { create(:task, project: project, user: user) }

      it_behaves_like 'accessible to authenticated users'
    end

    context 'when project owner' do
      let(:project) { create(:project, user: user) }

      it_behaves_like 'accessible to authenticated users'
    end

    context 'when admin' do
      it_behaves_like 'accessible to admin users'
    end
  end

  describe 'DELETE #destroy' do
    subject(:request) do
      delete project_task_path(task, project_id: project)
    end

    let(:project) { create(:project) }
    let(:team) { create(:team, project: project) }
    let(:task) { create(:task, project: project) }

    context 'when not logged in' do
      it_behaves_like 'not accessible to unauthenticated users'
    end

    context 'when not in project' do
      before { sign_in user }

      it_behaves_like 'returns 404 Not Found'
    end

    context 'when not task owner' do
      before do
        project.unassigned_team.users << user
        sign_in user
      end

      it_behaves_like 'returns 404 Not Found'
    end

    context 'when task owner' do
      let(:task) { create(:task, project: project, user: user) }

      it_behaves_like 'accessible to authenticated users'
    end

    context 'when project owner' do
      let(:project) { create(:project, user: user) }

      it_behaves_like 'accessible to authenticated users'
    end

    context 'when admin' do
      it_behaves_like 'accessible to admin users'
    end
  end

  describe 'GET #data' do
    subject(:request) do
      get data_project_tasks_path(project), params: params, xhr: true
    end

    let(:project) { create(:project) }
    let(:task) { create(:task, project: project) }
    let(:params) { { type: 'active' } }

    before do
      task.users << admin
    end

    context 'when not logged in' do
      it_behaves_like 'returns 401 Unauthorized'
    end

    context 'when not in project' do
      before { sign_in user }

      it_behaves_like 'returns 404 Not Found'
    end

    context 'when in project' do
      before { project.unassigned_team.users << user }

      it_behaves_like 'accessible to authenticated users'
    end

    context 'when not valid type' do
      let(:params) { { type: 'invalid type' } }

      before do
        project.unassigned_team.users << user
        sign_in user
      end

      it_behaves_like 'returns 404 Not Found'
    end

    context 'when project owner' do
      let(:project) { create(:project, user: user) }

      it_behaves_like 'accessible to authenticated users'
    end

    context 'when admin' do
      it_behaves_like 'accessible to admin users'
    end
  end

  describe 'PATCH #set_percentage' do
    subject(:request) do
      patch set_percentage_project_task_path(task, project_id: project),
            params: params
    end

    let(:project) { create(:project) }
    let(:task) { create(:task, project: project) }
    let(:params) { { task: { percentage: 50 } } }

    context 'when not logged in' do
      it_behaves_like 'not accessible to unauthenticated users'
    end

    context 'when not in project' do
      before { sign_in user }

      it_behaves_like 'returns 404 Not Found'
    end

    context 'when invalid input' do
      let(:params) {  { task: { percentage: 200 } } }

      before do
        task.users << user
        sign_in user
      end

      it_behaves_like 'returns 422 Unprocessable Entity'
    end

    context 'when assigned to task' do
      before { task.users << user }

      it_behaves_like 'accessible to authenticated users'
    end

    context 'when task owner' do
      let(:task) { create(:task, project: project, user: user) }

      it_behaves_like 'accessible to authenticated users'
    end

    context 'when project owner' do
      let(:project) { create(:project, user: user) }

      it_behaves_like 'accessible to authenticated users'
    end

    context 'when admin' do
      it_behaves_like 'accessible to admin users'
    end
  end
end
