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

    %w[name_asc name_desc date_asc date_desc].each do |sort|
      context "with valid input, sort method: #{sort}" do
        let(:params) do
          {
            page: 1,
            name: 'test',
            category: 'test',
            status: 'active',
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
  end

  describe 'GET #self' do
    subject(:request) { get self_projects_path }

    it_behaves_like 'accessible to authenticated users'
    it_behaves_like 'not accessible to unauthenticated users'
  end
end
