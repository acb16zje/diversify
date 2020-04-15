# frozen_string_literal: true

require 'rails_helper'

describe 'New Project > Project', :js, type: :system do
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }

  before do
    create_list(:category, 3)
    sign_in admin
    visit projects_path
  end

  context 'when creates the private project' do
    before { click_link_or_button 'New Project' }

    it do
      fill_in 'project_name', with: 'New Project'
      find('#project_visibility_false').click
      click_button 'Create Project'
      expect(page).to have_content('Project Created', wait: 15)
    end
  end

  context 'when other user search private project' do
    it do
      create(:project, :private, name: 'Test', user: admin)
      sign_in user
      visit explore_projects_path
      expect(page).to have_no_content('Test')
    end
  end
end
