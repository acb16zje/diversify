# frozen_string_literal: true

require 'rails_helper'

describe 'Task > Manage Task', :js, type: :system do
  let(:owner) { create(:user) }
  let(:project) { create(:project, user: owner) }

  before do
    sign_in owner
    visit project_path(project)
    find('a', text: 'Tasks').click
  end

  context 'when task is in progress' do
    let!(:task) { create(:task, user: owner, project: project) }

    before do
      find('a', text: 'Active').click
      find(:xpath, "//tbody/tr/td[@class='chevron-cell']").click
    end

    it 'can delete task' do
      accept_confirm { find('a', text: 'Delete Task', visible: true).click }
      expect(page).to have_no_content(task.name)
    end

    it 'can set task as completed' do
      find(:xpath, "//div/div[@style='left: 90%;']").click(x: 20, y: 0)
      find('a', text: 'Completed').click
      expect(page).to have_content(task.name)
    end
  end

  context 'when task is completed' do
    let!(:task) { create(:task, :completed, user: owner, project: project) }

    before do
      find('a', text: 'Completed').click
      find(:xpath, "//tbody/tr/td[@class='chevron-cell']").click
    end

    it 'can set task as incomplete' do
      find(:xpath, "//div/div[@style='left: 50%;']").click
      find('a', text: 'Active').click
      expect(page).to have_content(task.name)
    end
  end
end
