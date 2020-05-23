# frozen_string_literal: true

require 'rails_helper'

describe 'Show Dashboard > Admin', :js, type: :system do
  let(:admin) { create(:admin) }

  before do
    sign_in admin
    visit admin_skills_path
  end

  describe 'show admin skills page' do
    it 'shows skills' do
      expect(page).to have_content('Skills')
    end
  end

  describe 'add new skill' do
    before do
      create_list(:category, 3)
      visit admin_skills_path
    end

    it 'can add new skill' do
      click_button 'New skill'
      find('.modal .input').set('new skill')
      find(:xpath, './/select/option[1]').select_option
      click_button 'Create skill'
      expect(page).to have_content('Skill added')
    end
  end

  describe 'when user manage skills' do
    before do
      create(:skill)
      visit admin_skills_path
    end

    it 'can edit skill name' do
      click_button 'Edit'
      find('.modal .input').set('new skill')
      click_button 'Save changes'
      expect(page).to have_content('Skill updated')
    end

    it 'can edit skill category' do
      click_button 'Edit'
      find(:xpath, './/select/option[1]').select_option
      click_button 'Save changes'
      expect(page).to have_content('Skill updated')
    end

    it 'can delete skills' do
      click_button 'Delete'
      click_button 'I understand the consequences, delete this skill'
      expect(page).to have_content('Skill deleted')
    end
  end
end
