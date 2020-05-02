# frozen_string_literal: true

require 'rails_helper'

describe 'Team > Manage Team', :js, type: :system do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }

  before do
    sign_in user
    @team = create(:team, name: 'Test', project: project)
    visit "projects/#{project.id}/teams/manage"
  end

  context 'when edit existing team' do
    before { click_link_or_button 'Edit Team' }

    it 'can change team name' do
      fill_in 'team_name', with: 'New Team'
      click_button 'Save Team'
      expect(page).to have_content('New Team', wait: 15)
    end

    it 'can change team size' do
      fill_in 'team_team_size', with: '3'
      click_button 'Save Team'
      expect(page).to have_content('Members: 0 / 3', wait: 15)
    end
  end

  it 'can delete existing team' do
    click_link_or_button 'Delete Team'
    expect(page).to have_no_content('Test', wait: 15)
  end

  describe 'manage members' do
    context 'when assign member to team' do
      # it 'can assign unassigned member to team' do
      #   element = find('p', text: user.name, visible: true)
      #   target = find(:id, @team.id, visible: :all)
      #   element.drag_to target
      #   click_button 'Save'
      #   expect(page).to have_content('Members: 1 / 5', wait: 15)
      # end

      # it 'can change assigned member to other team' do
      #
      # end
      #
      # it 'can unassign assigned member' do
      #
      # end
    end

    # context 'when reset the assignment' do
    #   it do
    #
    #   end
    # end
    #
    context 'when goes back to previous page' do
      it do
        click_link_or_button 'Back'
        expect(page).to have_content(project.name, wait: 15)
      end
    end

    context 'when creates new team while manage team' do
      it do
        click_link_or_button 'New Team'
        expect(page).to have_content('Create Team', wait: 15)
      end
    end
  end
end
