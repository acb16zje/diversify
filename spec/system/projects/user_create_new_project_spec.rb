# frozen_string_literal: true

require 'rails_helper'

describe 'New Project > Project', :js, type: :system do
  let(:user) { create(:user) }

  before do
    create(:project, name: 'Test', user: user, status: 'active')
    create(:project,
           name: 'Test2', user: user, status: 'open', created_at: 1.day.ago)
    create_list(:category, 3)
    sign_in user
    visit 'projects/new'
  end

  context 'when creates the project' do
    it 'fills title only' do
      fill_in 'project_name', with: 'New Project'
      click_button 'Create Project'
      expect(page).to have_content('Project Created')
    end

    it 'can choose category' do
      fill_in 'project_name', with: 'New Project'
      find(:xpath, "//*[@id='project_category_id']/option[2]").select_option
      click_button 'Create Project'
      expect(page).to have_content('Project Created')
    end

    it 'can write description' do
      fill_in 'project_name', with: 'New Project'
      fill_in 'project_description', with: 'New Description'
      click_button 'Create Project'
      expect(page).to have_content('Project Created')
    end

    it 'with title is missing' do
      fill_in 'project_description', with: 'New Description'
      click_button 'Create Project'
      expect(page).to have_no_content('Project Created')
    end
  end
end
