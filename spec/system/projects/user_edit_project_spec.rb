# frozen_string_literal: true

require 'rails_helper'

describe 'Edit Project > Project', :js, type: :system do
  let(:user) { create(:user) }
  let(:category1) { create(:category) }
  let(:project) { create(:project, user: user, category_id: category1.id) }
  let(:project_archive) { create(:project, user: user, status: 'completed') }

  before do
    create_list(:category, 3)
    sign_in user
    visit "projects/#{project.id}"
  end

  context 'when views project page' do
    it 'shows project' do
      expect(page).to have_content("Owned by: #{user.name}")
    end
  end

  context 'when edits project' do
    before { find('a', text: 'Settings').click }

    it 'can access edit form' do
      expect(page).to have_content('Project Details')
    end

    it 'can choose category' do
      fill_in 'project_name', with: 'New Project'
      find(:xpath, "//*[@id='project_category_id']/option[2]").select_option
      click_on 'Save changes'
      expect(page).to have_content('Project Updated')
    end

    it 'can write description' do
      fill_in 'project_name', with: 'New Project'
      find(:xpath, "//*[@id='project_category_id']/option[2]").select_option
      fill_in 'project_description', with: 'New Description'
      click_button 'Save changes'
      expect(page).to have_content('Project Updated')
    end

    it 'title is missing' do
      fill_in 'project_name', with: ''
      click_button 'Save changes'
      expect(page).to have_no_content('Project Updated')
    end
  end

  context 'when project archived' do
    before do
      visit "projects/#{project_archive.id}"
      find('a', text: 'Settings').click
    end

    it 'can access edit form' do
      expect(page).to have_content('Project Details')
    end

    it 'can unarchive project' do
      click_button 'Unarchive project'
      page.accept_alert
      expect(page).to have_content('Project Activated')
    end
  end
end
