# frozen_string_literal: true

require 'rails_helper'

describe 'Show Profile > User', :js, type: :system do
  let(:user) { create(:user) }
  let(:skill) { create(:skill) }
  let(:personality) { create(:personality, :infj) }
  let(:personality_user) { create(:user, personality: personality) }
  let(:project) { create(:project_with_members) }

  before do
    sign_in user
    visit user_path(user)
  end

  describe 'show user profile' do
    it 'shows user profile' do
      expect(page).to have_content(user.name)
    end
  end

  describe 'can redirect to edit user profile' do
    it 'redirects to user profile' do
      click_link 'Edit'
      expect(page).to have_content('Public Avatar')
    end
  end

  describe 'when viewing profile tab' do
    context 'when user has no personality' do
      it 'shows no personality' do
        expect(page).to have_content('No personality set')
      end
    end

    context 'when user has personality' do
      before do
        visit user_path(personality_user)
      end

      it 'shows personality' do
        expect(page).to have_no_content('No personality set')
      end
    end

    context 'when user has no skill' do
      it 'shows no skill' do
        expect(page).to have_content('No data')
      end
    end

    context 'when user has skill' do
      before do
        visit settings_skills_path
      end

      it 'shows skill' do
        expect(page).to have_no_content('No data')
      end
    end
  end

  describe 'when viewing skills tab' do
    before do
      find('a', text: 'Skills').click
    end

    context 'when user has no skills' do
      it 'shows no skills' do
        expect(page).to have_content('No Skills')
      end
    end

    context 'when user has skills' do
      before do
        create(:user_skill, user: user, skill: skill)
        visit settings_skills_path
      end

      it 'shows skills message' do
        expect(page).to have_no_content('No Skills')
          .and have_content(skill.name)
      end
    end
  end

  describe 'when viewing timeline tab' do
    before do
      find('a', text: 'Timeline').click
    end

    it 'shows timeline data' do
      expect(page).to have_content('User Joined Diversify')
    end
  end

  describe 'when viewing joined projects tab' do
    before do
      find('a', text: 'Joined Projects').click
    end

    context 'when user has not joined any project' do
      it 'shows no projects' do
        expect(page).to have_content('No projects')
      end
    end

    context 'when user has joined project' do
      before do
        create(:collaboration,
               user: user,
               team: create(:team,
                            project: project))
        visit user_path(user)
        find('a', text: 'Joined Projects').click
      end

      it 'shows projects' do
        expect(page).to have_no_content('No projects')
          .and have_content(project.name)
      end
    end
  end

  describe 'when viewing personal projects tab' do
    before do
      find('a', text: 'Personal Projects').click
    end

    context 'when user has no personal projects' do
      it 'shows no projects' do
        expect(page).to have_content('No projects')
      end
    end

    context 'when user has personal projects' do
      before do
        create(:project, user: user)
        visit user_path(user)
        find('a', text: 'Personal Projects').click
      end

      it 'shows projects' do
        expect(page).to have_no_content('No projects')
      end
    end
  end
end
