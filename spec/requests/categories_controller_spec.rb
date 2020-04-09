# frozen_string_literal: true

require 'rails_helper'

describe CategoriesController, type: :request do
  let(:user) { create(:user) }

  before do |test|
    sign_in user unless test.metadata[:no_sign_in]
  end

  describe 'GET #index', :no_sign_in do
    subject(:request) { get categories_path }

    it_behaves_like 'accessible to authenticated users'
    it_behaves_like 'accessible to unauthenticated users'
  end

  describe 'GET #index JSON' do
    subject(:request) do
      get categories_path, xhr: true, headers: { accept: 'application/json' }
    end

    it_behaves_like 'returns JSON response'
  end
end
