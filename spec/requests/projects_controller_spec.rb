# frozen_string_literal: true

require 'rails_helper'

describe ProjectsController, type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }
  let(:project) { create(:project) }
  let(:private_project) { create(:project, :private, user: admin) }
  let(:owned_project) { create(:project, :private, user: user) }
  SORT_TIME = %w[name_asc name_desc date_asc date_desc]

  describe 'authorisations' do
    before { sign_in user }

    it 'has authorized scope' do
      expect { post query_projects_path,params: {
          page: 1,
          name: 'test',
          category: 'test',
          status: 'Ongoing',
          sort: 'name_asc'
        }
      }.to have_authorized_scope(:active_record_relation)
        .with(ProjectPolicy)
    end
  end

  describe 'GET #index' do
    shared_examples 'shows projects index' do
      it {
        get projects_path(user)
        expect(response).to have_http_status(:ok)
      }
    end

    context 'when signed in as in ' do
      before { sign_in user }

      it_behaves_like 'shows projects index'
    end

    describe 'when signed out' do
      it_behaves_like 'shows projects index'
    end
  end

  describe 'POST #query' do
    context 'with valid input' do
      SORT_TIME.each do |sort|
        it {
          post query_projects_path, params: {
            page: 1,
            name: 'test',
            category: 'test',
            status: 'Ongoing',
            sort: sort
          }
          expect(response).to have_http_status(:ok)
        }
      end
    end

    context 'with invalid input' do
      it {
        post query_projects_path, params: {
          page: 'bla',
          name: '',
          category: 'test',
          status: 'Ongoing',
          sort: 'name_asc'
        }
        expect(response).to have_http_status(:bad_request)
      }
    end
  end

  describe 'GET #show' do
    shared_examples 'shows public projects page' do
      it {
        get project_path(project)
        expect(response).to have_http_status(:ok)
      }
    end

    context 'when signed in' do
      before { sign_in user }

      it_behaves_like 'shows public projects page'
      it 'does not allow access for not owned private project' do
        get project_path(private_project)
        expect(response).to have_http_status(:forbidden)
      end
      it 'allow access for owned private project' do
        get project_path(owned_project)
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'when signed out' do
      it_behaves_like 'shows public projects page'
      it 'does not allow access for private project' do
        get project_path(private_project)
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end