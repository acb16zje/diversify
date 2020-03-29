# frozen_string_literal: true

require 'rails_helper'

describe ProjectsController, type: :request do
  let(:user) { create(:user) }

  describe 'authorisations' do
    subject(:request) do
      post query_projects_path, params: {
        page: 1,
        name: 'test',
        category: 'test',
        status: 'active',
        sort: 'name_asc',
        type: 'projects'
      }
    end

    before { sign_in user }

    it 'has authorized scope' do
      expect { request }
        .to have_authorized_scope(:active_record_relation).with(ProjectPolicy)
    end
  end

  describe 'GET #index' do
    subject(:request) { get projects_path(user) }

    it_behaves_like 'accessible to authenticated users'
    it_behaves_like 'accessible to unauthenticated users'
  end

  describe 'POST #query' do
    subject(:request) { post query_projects_path, params: params }

    let(:project) { create(:project) }

    %w[name_asc name_desc date_asc date_desc].each do |sort|
      context "with valid input, sort method: #{sort}" do
        let(:params) do
          {
            page: 1,
            name: project.name,
            category: project.category.id,
            status: 'Active',
            sort: sort,
            type: 'projects'
          }
        end

        it_behaves_like 'accessible to authenticated users'
        it_behaves_like 'accessible to unauthenticated users'
      end
    end

    context 'with invalid input' do
      let(:params) do
        {
          page: 'bla',
          name: '',
          category: 'test',
          status: 'active',
          sort: 'name_asc',
          type: 'bla'
        }
      end

      it_behaves_like 'returns 400 Bad Request'
    end
  end

  describe 'GET #show' do
    subject(:request) { get project_path(project) }

    let(:admin) { create(:admin) }

    context 'with owned public project' do
      let(:project) { create(:project, user: user) }

      it_behaves_like 'accessible to authenticated users'
      it_behaves_like 'accessible to unauthenticated users'
    end

    context 'with not owned public project' do
      let(:project) { create(:project, user: admin) }

      it_behaves_like 'accessible to authenticated users'
      it_behaves_like 'accessible to unauthenticated users'
    end

    context 'with owned private project' do
      let(:project) { create(:project, :private, user: user) }

      it_behaves_like 'accessible to authorised users'
    end

    context 'with not owned private project' do
      let(:project) { create(:project, :private, user: admin) }

      it_behaves_like 'not accessible to unauthorised users'
    end

    context 'with joined private project' do
      let(:project) { create(:project, :private, user: admin) }

      before { project.teams.find_by(name: 'Unassigned').users << user }

      it_behaves_like 'accessible to authorised users'
    end
  end

  describe 'GET #self' do
    subject(:request) { get self_projects_path }

    it_behaves_like 'accessible to authenticated users'
    it_behaves_like 'not accessible to unauthenticated users'
  end

  describe 'GET #new' do
    subject(:request) { get new_project_path }

    it_behaves_like 'accessible to authenticated users'
    it_behaves_like 'not accessible to unauthenticated users'
  end

  describe 'POST #create' do
    subject(:request) { post projects_path, params: params }

    let(:category) { create(:category) }

    context 'with valid inputs' do
      let(:params) do
        { project: { name: 'Test', description: 'Test',
                     category_id: category.id } }
      end

      it_behaves_like 'accessible to authenticated users'
      it_behaves_like 'not accessible to unauthenticated users'
    end

    context 'with invalid inputs' do
      let(:params) do
        { project: { name: 'Test', description: 'Test',
                     category_id: 'a' } }
      end

      before { sign_in user }

      it_behaves_like 'returns 422 Unprocessable Entity'
    end

    context 'when set visibility with valid license' do
      let(:params) do
        { project: { name: 'Test', description: 'Test',
                     visibility: 'false', category_id: category.id } }
      end

      before { user.license.plan = 'pro' }

      it_behaves_like 'accessible to authenticated users'
    end
  end

  describe 'POST #update' do
    subject(:request) { patch project_path(project), params: params }

    let(:project) { create(:project, user: user) }
    let(:category) { create(:category) }

    context 'with valid inputs' do
      let(:params) do
        { project: {
          name: 'Test', description: 'Test',
          category_id: category.id,
          avatar: fixture_file_upload('spec/fixtures/squirtle.png')
        } }
      end

      it_behaves_like 'accessible to authenticated users'
      it_behaves_like 'not accessible to unauthenticated users'
    end

    context 'with invalid inputs' do
      let(:params) do
        { project: {
          name: 'Test', description: 'Test',
          category_id: 'a',
          avatar: fixture_file_upload('spec/fixtures/squirtle.png')
        } }
      end

      before { sign_in user }

      it_behaves_like 'returns 422 Unprocessable Entity'
    end

    context 'when set visibility with valid license' do
      let(:params) do
        { project: { name: 'Test', description: 'Test',
                     visibility: 'false', category_id: category.id } }
      end

      before { user.license.plan = 'pro' }

      it_behaves_like 'accessible to authenticated users'
    end

    context 'when not owner of project' do
      let(:user2) { create(:user) }
      let(:params) do
        { project: { name: 'Test', description: 'Test',
                     category_id: category.id } }
      end

      before { sign_in user2 }

      it_behaves_like 'returns 404 Not Found'
    end
  end

  describe 'POST #change_status' do
    subject(:request) {
      post change_status_project_path(project), params: params
    }

    %w[Open Completed Active].each do |status|
      context 'with valid status change' do
        let(:project) { create(:project, user: user) }
        let(:params) do
          { status: status }
        end

        it_behaves_like 'accessible to authenticated users'
        it_behaves_like 'not accessible to unauthenticated users'
      end
    end

    context 'with invalid status change' do
      let(:project) { create(:project, user: user, status: 'Open') }
      let(:params) do
        { status: 'Completed' }
      end

      before { sign_in user }

      it_behaves_like 'returns 422 Unprocessable Entity'
    end

    context 'when not project owner' do
      let(:user2) { create(:user) }
      let(:project) { create(:project, user: user, status: 'Active') }
      let(:params) do
        { status: 'Open' }
      end

      before { sign_in user2 }

      it_behaves_like 'returns 404 Not Found'
    end
  end
end
