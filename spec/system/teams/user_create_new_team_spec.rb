# frozen_string_literal: true

require 'rails_helper'

describe 'Project > Create team', :js, type: :system do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:project) { create(:project, user: user, category_id: category.id) }

  before do
    create(:skill, category_id: category.id)
    sign_in user
    visit "projects/#{project.id}"
  end

  context 'when creates new team' do
    before { click_link_or_button 'New Team' }

    it do
      fill_in 'team_name', with: 'New Team'
      fill_in 'team_team_size', with: '2'
      click_button 'Create Team'
      expect(page).to have_content('New Team', wait: 15)
    end

    it 'team name is missing' do
      fill_in 'team_team_size', with: '2'
      click_button 'Create Team'
      expect(page).to have_no_content('Team Successfully Created', wait: 15)
    end

    it 'set skills' do
      fill_in 'team_name', with: 'New Team'
      fill_in 'team_team_size', with: '2'
      find(:xpath, "//*[@id='team_skill_ids']/option[1]").select_option
      click_button 'Create Team'
      expect(page).to have_content('New team', wait: 15)
    end

    it 'team size is blank' do
      fill_in 'team_name', with: 'New Team'
      click_button 'Create Team'
      expect(page).to have_no_content('New Team', wait: 15)
    end

    it 'team size is 0' do
      fill_in 'team_name', with: 'New Team'
      fill_in 'team_team_size', with: '0'
      click_button 'Create Team'
      expect(page).to have_no_content('Team Successfully Created', wait: 15)
    end

    it 'team size is negative number' do
      fill_in 'team_name', with: 'New Team'
      fill_in 'team_team_size', with: '-1'
      click_button 'Create Team'
      expect(page).to have_no_content('Team Successfully Created', wait: 15)
    end

    it 'team name already exists' do
      create(:team, project: project, name: 'New team')
      fill_in 'team_name', with: 'New Team'
      fill_in 'team_team_size', with: '2'
      click_button 'Create Team'
      expect(page).to have_no_content('Team Successfully Created', wait: 15)
    end
  end
end
