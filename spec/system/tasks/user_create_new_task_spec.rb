# frozen_string_literal: true

require 'rails_helper'

describe 'Project > Create Task', :js, type: :system do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let!(:skill_1) { create(:skill, category_id: category.id) }
  let!(:skill_2) { create(:skill, category_id: category.id) }
  let(:project) { create(:project, user: user, category_id: category.id) }

  before do
    sign_in user
    visit "projects/#{project.id}/tasks/new"
  end

  context 'when creates new task' do
    it 'without Assignee' do
      fill_in 'task_name', with: 'Test Task'
      click_button 'Create Task'
      expect(page).to have_content('Task created')
      find('a', text: 'Tasks').click
      find(".select option[value='unassigned']").select_option
      expect(page).to have_content('Test Task')
    end

    it 'puts description' do
      fill_in 'task_name', with: 'Test Task'
      fill_in 'task_description', with: 'Random description'
      click_button 'Create Task'
      expect(page).to have_content('Task created')
      find('a', text: 'Tasks').click
      find(".select option[value='unassigned']").select_option
      expect(page).to have_content('Test Task')
      find(:xpath, "//tbody/tr/td[@class='chevron-cell']").click
      expect(page).to have_content('Random description')
    end

    it 'change priority' do
      fill_in 'task_name', with: 'Test Task'
      find('#task_priority').find(:xpath, 'option[3]').select_option
      click_button 'Create Task'
      expect(page).to have_content('Task created')
      find('a', text: 'Tasks').click
      find(".select option[value='unassigned']").select_option
      expect(page).to have_content('Low')
    end

    it 'set skills' do
      fill_in 'task_name', with: 'Test Task'
      find('#task_skills_id').find(:xpath, 'option[2]').select_option
      click_button 'Create Task'
      expect(page).to have_content('Task created')
      find('a', text: 'Tasks').click
      find(".select option[value='unassigned']").select_option
      expect(page).to have_content('Test Task')
      find(:xpath, "//tbody/tr/td[@class='chevron-cell']").click
      expect(page).to have_content(skill_2.name)
    end

    it 'with assignee' do
      fill_in 'task_name', with: 'Test Task'
      find('#task_users_id').find(:xpath, 'option[1]').select_option
      click_button 'Create Task'
      expect(page).to have_content('Tasks')
      find('a', text: 'Tasks').click
      expect(page).to have_xpath('//tbody/tr/td[6]/div/div/span')
    end

    it 'title is missing' do
      fill_in 'task_description', with: 'Random description'
      click_button 'Create Task'
      expect(page).to have_no_content('Task created')
    end
  end
end
