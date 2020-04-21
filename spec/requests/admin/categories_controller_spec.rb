# frozen_string_literal: true

require 'rails_helper'

describe Admin::CategoriesController, type: :request do
  let(:admin) { create(:admin) }
  let(:category) { create(:category) }

  before { sign_in admin }

  describe 'GET #index' do
    subject(:request) { get admin_categories_path }

    it_behaves_like 'returns 200 OK'
  end

  describe 'POST #create' do
    subject(:request) { post admin_categories_path, params: params }

    context 'with new name' do
      let(:params) { { category: { name: 'newname' } } }

      it_behaves_like 'returns 200 OK'
    end

    context 'with duplicate name' do
      let(:params) { { category: { name: category.name } } }

      it_behaves_like 'returns 422 Unprocessable Entity'
    end
  end

  describe 'PATCH #update' do
    subject(:request) do
      patch admin_category_path(category), params: params
    end

    context 'with new name' do
      let(:params) { { category: { name: 'newname' } } }

      it_behaves_like 'returns 200 OK'
    end

    context 'without changes' do
      let(:params) { { category: { name: category.name } } }

      it_behaves_like 'returns 200 OK'
    end

    context 'with duplicate name' do
      let(:category2) { create(:category) }
      let(:params) { { category: { name: category2.name } } }

      it_behaves_like 'returns 422 Unprocessable Entity'
    end
  end

  describe 'DELETE #destroy' do
    subject(:request) { delete admin_category_path(category) }

    it_behaves_like 'returns 200 OK'
  end
end
