# frozen_string_literal: true

require 'rails_helper'

describe 'Join Project > Project', :js, type: :system do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user, category: create(:category)) }
  let(:project_open) { create(:project, user: user, status: 'open') }
  let(:project_other) { create(:project, status: 'open') }
  let(:project_other_closed) { create(:project) }

  before { sign_in user }

  context 'when closed project page application tab' do
    before do
      visit "projects/#{project.id}"
      find('a', text: 'Applications').click
    end

    it 'can access applications tab' do
      expect(page).to have_content('Application: Closed')
    end

    it 'can open application' do
      click_on 'Open application'
      page.accept_alert
      expect(page).to have_content('Project Opened')
    end
  end

  context 'when open project page application tab' do
    before do
      visit "projects/#{project_open.id}"
      find('a', text: 'Applications').click
    end

    it 'can close project' do
      click_on 'Close application'
      page.accept_alert
      expect(page).to have_content('Project Closed')
    end
  end

  context 'when viewing other users application tab' do
    it 'can join users project' do
      visit "projects/#{project_other.id}"
      click_on 'Join'
      page.accept_alert
      expect(page).to have_content('Application sent')
    end

    it 'can not join users project' do
      visit "projects/#{project_other_closed.id}"
      expect(page).to have_no_content('Join')
    end

    it 'can cancel application' do
      visit "projects/#{project_other.id}"
      click_on 'Join'
      page.accept_alert
      click_on 'Cancel Application'
    end
  end
end
