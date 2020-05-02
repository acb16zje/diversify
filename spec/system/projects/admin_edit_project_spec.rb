# frozen_string_literal: true

require 'rails_helper'

describe 'Edit Project > Project', :js, type: :system do
  let(:admin) { create(:admin) }
  let(:project) { create(:project, :private, user: admin, category: create(:category)) }

  before do
    sign_in admin
    visit "projects/#{project.id}"
    find('a', text: 'Settings').click
  end

  context 'when project is private' do
    it 'can change to public' do
      page.check('project_visibility')
      click_button 'Save Settings'
      find('a', text: 'Settings').click
      expect(page).to have_field('project_visibility', checked: true)
    end
  end
end
