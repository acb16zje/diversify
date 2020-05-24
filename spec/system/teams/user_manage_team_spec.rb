# frozen_string_literal: true

require 'rails_helper'

describe 'Team > Manage Team', :js, type: :system do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }

  before do
    sign_in user
    create(:team, name: 'Test', project: project)
    visit "projects/#{project.id}/teams/manage"
  end

  context 'when edit existing team' do
    before { click_link_or_button 'Edit Team' }

    it 'can change team name' do
      fill_in 'team_name', with: 'New Team'
      click_button 'Save'
      expect(page).to have_content('New Team')
    end

    it 'can change team size' do
      fill_in 'team_team_size', with: '3'
      click_button 'Save'
      expect(page).to have_content('Members: 0 / 3')
    end
  end

  it 'can delete existing team' do
    click_link_or_button 'Delete Team'
    expect(page).to have_no_content('Test')
  end

  describe 'manage members' do
    context 'when goes back to previous page' do
      it do
        click_link_or_button 'Back'
        expect(page).to have_content(project.name)
      end
    end

    context 'when creates new team while manage team' do
      it do
        click_link_or_button 'New Team'
        expect(page).to have_content('Create Team')
      end
    end
  end
end
