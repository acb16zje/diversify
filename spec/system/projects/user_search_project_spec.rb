# frozen_string_literal: true

require 'rails_helper'

describe 'Search Project > Project', :js, type: :system do
  let(:user) { create(:user) }

  before do
    create(:project, name: 'Test', user: user, status: 'active')
    create(:project,
           name: 'Test2', user: user, status: 'open', created_at: 1.day.ago)
    create_list(:category, 3)
    sign_in user
    visit projects_path
  end

  context 'when search project' do
    it 'using search bar' do
      find("input[placeholder='Find a project...']").set 'Test2'
      expect(page).to have_content('Test2')
    end

    it 'sort by status' do
      click_button 'Status'
      find('a.dropdown-item', text: 'Open').click
      expect(page).to have_content('Test2')
    end

    it 'sort by categories' do
      click_button 'Category'
      find(:xpath, "//a[@class='dropdown-item'][2]").click
      expect(page).to have_content('Test2')
    end

    it 'sort by newest' do
      click_button 'Sort'
      find('a.dropdown-item', text: 'Recently created').click
      within('#project-list-holder') do
        expect(page).to have_content('Test')
      end
    end

    it 'sort by oldest' do
      click_button 'Sort'
      find('a.dropdown-item', text: 'Oldest created').click
      within('#project-list-holder') do
        expect(page).to have_content('Test2')
      end
    end

    it 'sort by name' do
      click_button 'Sort'
      find('a.dropdown-item', text: 'Name').click
      within('#project-list-holder') do
        expect(page).to have_content('Test')
      end
    end
  end
end
