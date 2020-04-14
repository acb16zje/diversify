# frozen_string_literal: true

require 'rails_helper'

describe 'New Project > Project', :js, type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
    visit projects_path
    click_link_or_button 'New Project'
  end

  context 'creates the corret project' do
    it 'fills title only' do
      fill_in 'project_name', with: 'New Project'
      select 'Accounting and Finance', from: 'project_category_id'
      click_button 'Create Project'
      expect(page).to have_content('Project Created')
    end

    it 'can choose category' do
      fill_in 'project_name', with: 'New Project'
      select 'Computer and IT', from: 'project_category_id'
      click_button 'Create Project'
      expect(page).to have_content('Project Created')
    end

    it 'can write description' do
      fill_in 'project_name', with: 'New Project'
      fill_in 'project_description', with: 'New Description'
      click_button 'Create Project'
      expect(page).to have_content('Project Created')
    end

    it 'title is missing' do
      click_button 'Create Project'
      expect(page).to have_no_content('Project Created')
    end

    it 'category is missing' do
      fill_in 'project_name', with: 'New Project'
      click_button 'Create Project'
      expect(page).to have_no_content('Project Created')
    end
  end
end
