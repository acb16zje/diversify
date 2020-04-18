# frozen_string_literal: true

require 'rails_helper'

describe 'Invite User > Invites', :js, type: :system do
  let(:user) { create(:user) }
  let(:user_invite) { create(:user) }
  let(:project) { create(:project, user: user, category: create(:category)) }

  context 'when inviting user' do
    before do
      sign_in user
      visit "projects/#{project.id}"
      find('a', text: 'Applications').click
    end

    it 'with invalid email' do
      find("input[placeholder='Email']").set 'random'
      click_on 'Invite'
      expect(page).to have_content('No Invitation')
    end

    it 'can invite user' do
      find("input[placeholder='Email']").set user_invite.email
      click_on 'Invite'
      expect(page).to have_content('Invitation Sent')
    end
  end

  context 'when invited other user' do
    before do
      create(:invite, user: user_invite, project: project)
      sign_in user
      visit "projects/#{project.id}"
      find('a', text: 'Applications').click
    end

    it 'can cancel users invite' do
      find('a', text: 'Cancel Invite').click
      page.accept_alert
      expect(page).to have_content('Invite Canceled')
    end
  end

  context 'when invited by other user' do
    before do
      create(:invite, user: user_invite, project: project)
      sign_in user_invite
      visit "projects/#{project.id}"
    end

    it 'can accept invite' do
      click_on 'Accept Invite'
      page.accept_alert
      expect(page).to have_content('Joined Project')
    end

    it 'can decline invite' do
      click_on 'Decline Invite'
      page.accept_alert
      expect(page).to have_content('Invitation canceled')
    end
  end
end
