# frozen_string_literal: true

require 'rails_helper'

describe 'Show Dashboard > Admin', :js, type: :system do
  let(:admin) { create(:admin) }

  before do
    sign_in admin
    visit admin_categories_path
  end

  describe 'admin category page' do
    it { expect(page).to have_content('Categories') }
  end

  describe 'add new category' do
    it 'can add new category' do
      click_button 'New category'
      find('.modal .input').set('new category')
      click_button 'Create category'
      expect(page).to have_content('Category created')
    end
  end

  describe 'edit category' do
    before do
      create(:category)
      visit admin_categories_path
    end

    it 'can edit category' do
      click_button 'Edit'
      find('.modal .input').set('new category')
      click_button 'Save changes'
      expect(page).to have_content('Category updated')
    end
  end

  describe 'delete category' do
    before do
      create(:category)
      visit admin_categories_path
    end

    it 'can delete category' do
      click_button 'Delete'
      click_button 'I understand the consequences, delete this category'
      expect(page).to have_content('Category deleted')
    end
  end
end
