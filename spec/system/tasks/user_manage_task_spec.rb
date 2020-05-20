# frozen_string_literal: true

require 'rails_helper'

describe 'Task > Manage Task', :js, type: :system do
  let(:owner) { create(:user, :with_avatar) }
  let(:category) { create(:category) }
  let!(:skill) { create(:skill, category_id: category.id) }
  let(:project) { create(:project, user: owner, category_id: category.id) }
  let(:team) { create(:team, name: 'Test', project: project) }
  let!(:task) { create(:task, user_id: owner.id, project_id: project.id) }
  let!(:task_2) do
    create(:task, percentage: 100, user_id: owner.id, project_id: project.id)
  end
  let(:task_skill) do
    create(:task_skill, taks_id: task_id, skill_id: skill_1.id)
  end
  let(:task_user) { create(:task_user, taks_id: task_id, user_id: owner.id) }
  let(:task_user_2) do
    create(:task_user, taks_id: task_2_id, user_id: owner.id)
  end

  before do
    sign_in owner
    visit "projects/#{project.id}"
    find('a', text: 'Tasks').click
    find(".select option[value='active']").select_option
  end

  it 'delete task' do
    expect(page).to have_content(task.name)
    find(:xpath, "//tbody/tr/td[@class='chevron-cell']").click
    accept_confirm { find('a', text: 'Delete Task', visible: true).click }
    expect(page).to have_no_content(task.name)
  end

  it 'update progress of task' do
    expect(page).to have_content(task.name)
    find(:xpath, "//tbody/tr/td[@class='chevron-cell']").click
    find(:xpath, "//div/div[@style='left: 30%;']").click
    expect(page).to have_content('30%')
  end

  it 'make task complete' do
    find(".select option[value='completed']").select_option
    expect(page).to have_content(task_2.name)
  end

  it 'make task incomplete from complete' do
    find(".select option[value='completed']").select_option
    expect(page).to have_content(task_2.name)
    find(:xpath, "//tbody/tr/td[@class='chevron-cell']").click
    find(:xpath, "//div/div[@style='left: 40%;']").click
    find(".select option[value='active']").select_option
    expect(page).to have_content(task_2.name)
  end

  it 'check owner of task' do
    find('td', text: owner.name).click
    expect(page).to have_content(owner.name)
  end
end
