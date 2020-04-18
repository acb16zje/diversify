# frozen_string_literal: true

require 'rails_helper'

describe 'Join Project > Project', :js, type: :system do
  let(:user) { create(:user) }
  let(:user_invite) { create(:user) }
  let(:category1) { create(:category) }
  let(:project) { create(:project, user: user, category_id: category1.id) }
  let(:project_open) { create(:project, user: user, status: 'open') }
  let(:project_other) { create(:project, status: 'open') }
  let(:project_other_closed) { create(:project) }

  before do
    sign_in user
  end

  context 'when closed project page application tab' do
    before do
      visit "projects/#{project.id}"
      find('a', text: 'Applications').click
    end

    it 'can access applications tab' do
      expect(page).to have_content('Open Application')
    end

    it 'can open applications' do
      click_on 'Open Applications'
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
      click_on 'Close Application'
      page.accept_alert
      expect(page).to have_content('Project Closed')
    end
  end

  context 'when viewing other users application tab' do
    it 'can join users project' do
      visit "projects/#{project_other.id}"
      click_on 'Join'
      page.accept_alert
      expect(page).to have_content('Application Sent')
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

  context 'when inviting user on application tab' do
    before do
      visit "projects/#{project.id}"
      find('a', text: 'Applications').click
    end

    it 'with invalid email' do
      find("input[placeholder='Email']").set 'random'
      click_on 'Invite'
      expect(page).to have_content('No Invites')
    end

    it 'can invite user' do
      find("input[placeholder='Email']").set user_invite.email
      click_on 'Invite'
      expect(page).to have_content('Invite Sent')
    end
  end
end
