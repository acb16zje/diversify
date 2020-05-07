# frozen_string_literal: true

require 'rails_helper'

describe 'Task > Edit Task', :js, type: :system do
  let(:owner) { create(:user) }
  let(:member) { create(:user) }
  let(:category) { create(:category) }
  let!(:skill_1) { create(:skill, category_id: category.id) }
  let!(:skill_2) { create(:skill, category_id: category.id) }
  let(:project) { create(:project, user: owner, category_id: category.id) }
  let(:team) { create(:team, name: 'Test', project: project) }
  let(:task) { create(:task, user_id: owner.id, project_id: project.id) }
  let(:task_skill) { create(:task_skill, taks_id: task_id, skill_id: skill_1.id) }
  let(:task_user) { create(:task_user, taks_id: task_id, user_id: owner.id) }
  let(:collaboration) { create(:collaboration, user_id: member.id, team_id: team.id) }

  before do
    sign_in owner
    visit "projects/#{project.id}/tasks/#{task.id}/edit"
  end

  context 'when edits existing task' do
    it 'changes title' do
      fill_in 'task_name', with: 'Test Task'
      click_button 'Edit Task'
      expect(page).to have_content('Task updated', wait: 30)
      find('a', text: 'Tasks').click
      find(".select option[value='active']").select_option
      expect(page).to have_content('Test Task', wait: 15)
    end

    it 'changes description' do
      fill_in 'task_name', with: 'Test Task'
      fill_in 'task_description', with: 'Random description'
      click_button 'Edit Task'
      expect(page).to have_content('Task updated', wait: 15)
      find('a', text: 'Tasks').click
      find(".select option[value='active']").select_option
      expect(page).to have_content('Test Task', wait: 15)
      find(:xpath, "//tbody/tr/td[@class='chevron-cell']").click
      expect(page).to have_content('Random description', wait: 15)
    end

    it 'change skills' do
      fill_in 'task_name', with: 'Test Task'
      find('#task_skill_ids').find(:xpath, 'option[2]').select_option
      click_button 'Edit Task'
      expect(page).to have_content('Task updated', wait: 25)
      find('a', text: 'Tasks').click
      find(".select option[value='active']").select_option
      expect(page).to have_content('Test Task', wait: 15)
      find(:xpath, "//tbody/tr/td[@class='chevron-cell']").click
      expect(page).to have_content(skill_2.name, wait: 15)
    end

    it 'change assignee' do
      fill_in 'task_name', with: 'Test Task'
      find('#task_user_ids').find(:xpath, 'option[1]').select_option
      click_button 'Edit Task'
      expect(page).to have_content('Tasks', wait: 30)
      find('a', text: 'Tasks').click
      expect(page).to have_xpath("//tbody/tr/td[6]/div/div/span", wait: 30)
    end

    it 'title is missing' do
      fill_in 'task_name', with: ''
      click_button 'Edit Task'
      expect(page).to have_no_content('Task updated', wait: 15)
    end
  end
end
