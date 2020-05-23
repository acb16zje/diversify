# frozen_string_literal: true

require 'rails_helper'

describe 'Edit Skills > User', :js, type: :system do
  let(:user) { create(:user) }
  let(:skill) { create(:skill) }

  before do
    sign_in user
    visit settings_skills_path
  end

  describe 'show skill settings page' do
    it 'can open skills page' do
      expect(page).to have_content('Your skills')
    end
  end

  describe 'display skills to user' do
    context 'when user has no skills' do
      it 'displays no skills' do
        expect(page).to have_content('There are no skills added in your profile')
      end

      it 'can add skills' do
        click_button 'Add skills'
        fill_in placeholder: 'Search skills', with: skill.name
        find('.modal,is-active .dropdown-itemf').click
        click_button 'Save'
        expect(page).to have_content(skill.name)
      end
    end

    context 'when has skills' do
      before do
        create(:user_skill, user: user, skill: skill)
        visit settings_skills_path
      end

      it 'displays skills' do
        expect(page).to have_content(skill.name)
      end
    end
  end
end
