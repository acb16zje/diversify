# frozen_string_literal: true

require 'rails_helper'

describe 'Task > Edit Task', :js, type: :system do
  let(:owner) { create(:user) }
  let(:member) { create(:user) }
  let(:category) { create(:category) }
  let(:project) { create(:project, user: owner, category: category) }
  let(:task) { create(:task, user: owner, project: project) }

  let!(:skill) { create(:skill, category: category) }

  before do
    sign_in owner
    visit "projects/#{project.id}/tasks/#{task.id}/edit"
  end

  context 'when edits existing task' do
    it 'changes title' do
      fill_in 'task_name', with: 'Test Task'
      click_button 'Save'
      expect(page).to have_content('Task updated')
      find('a', text: 'Tasks').click
      find('a', text: 'Active').click
      expect(page).to have_content('Test Task')
    end

    it 'changes description' do
      fill_in 'task_name', with: 'Test Task'
      fill_in 'task_description', with: 'Random description'
      click_button 'Save'
      expect(page).to have_content('Task updated')
      find('a', text: 'Tasks').click
      find('a', text: 'Active').click
      expect(page).to have_content('Test Task')
      find(:xpath, "//tbody/tr/td[@class='chevron-cell']").click
      expect(page).to have_content('Random description')
    end

    it 'change skills' do
      fill_in 'task_name', with: 'Test Task'
      find('#task_skill_ids').find(:xpath, 'option[1]').select_option
      click_button 'Save'
      expect(page).to have_content('Task updated')
      find('a', text: 'Tasks').click
      find('a', text: 'Active').click
      expect(page).to have_content('Test Task')
      find(:xpath, "//tbody/tr/td[@class='chevron-cell']").click
      expect(page).to have_content(skill.name)
    end

    it 'change assignee' do
      fill_in 'task_name', with: 'Test Task'
      find('#task_user_ids').find(:xpath, 'option[1]').select_option
      click_button 'Save'
      expect(page).to have_content('Tasks')
      find('a', text: 'Tasks').click
      expect(page).to have_xpath('//tbody/tr/td[6]/div/div/span')
    end

    it 'title is missing' do
      fill_in 'task_name', with: ''
      click_button 'Save'
      expect(page).to have_no_content('Task updated')
    end
  end
end
