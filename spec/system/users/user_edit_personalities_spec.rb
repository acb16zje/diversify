# frozen_string_literal: true

require 'rails_helper'

describe 'New Personalities > User', :js, type: :system do
  let(:user) { create(:user) }
  # let(:personality) { create(:personality) }
  # let(:user_personality) { create(:user, :personality) }

  before do
    sign_in user
    visit settings_personality_path
  end

  describe 'personality not setted yet' do
    it 'did not make any change' do
      expect(page).to have_content('No Personality Set')
    end

    it 'try to save without any changes' do
      click_button 'Set Personality'
      expect(page).to have_content('Bad Request')
    end

    it 'try to save with lack of certain option' do
      choose('Introvert', allow_label_click: true)
      click_button 'Set Personality'
      expect(page).to have_content('Invalid Personality')
    end

  end

  describe 'set personalities' do
    it 'personality is ISFJ' do
      create(:personality)
      choose('Introvert', allow_label_click: true)
      choose('Observant', allow_label_click: true)
      choose('Feeling', allow_label_click: true)
      choose('Judging', allow_label_click: true)
      click_button 'Set Personality'
      expect(page).to have_content('ISFJ')
    end

    it 'personality is ISTJ' do
      create(:personality, :istj)
      choose('Introvert', allow_label_click: true)
      choose('Observant', allow_label_click: true)
      choose('Thinking', allow_label_click: true)
      choose('Judging', allow_label_click: true)
      click_button 'Set Personality'
      expect(page).to have_content('ISTJ')

    end

    it 'personality is INFJ' do
      create(:personality, :infj)
      choose('Introvert', allow_label_click: true)
      choose('Intuitive', allow_label_click: true)
      choose('Feeling', allow_label_click: true)
      choose('Judging', allow_label_click: true)
      click_button 'Set Personality'
      expect(page).to have_content('INFJ')
    end

    it 'personality is INTJ' do
      create(:personality, :intj)
      choose('Introvert', allow_label_click: true)
      choose('Intuitive', allow_label_click: true)
      choose('Thinking', allow_label_click: true)
      choose('Judging', allow_label_click: true)
      click_button 'Set Personality'
      expect(page).to have_content('INTJ')
    end

    it 'personality is ENFJ' do
      create(:personality, :enfj)
      choose('Extrovert', allow_label_click: true)
      choose('Intuitive', allow_label_click: true)
      choose('Feeling', allow_label_click: true)
      choose('Judging', allow_label_click: true)
      click_button 'Set Personality'
      expect(page).to have_content('ENFJ')
    end

    it 'personality is ISTP' do
      create(:personality, :istp)
      choose('Introvert', allow_label_click: true)
      choose('Observant', allow_label_click: true)
      choose('Thinking', allow_label_click: true)
      choose('Prospecting', allow_label_click: true)
      click_button 'Set Personality'
      expect(page).to have_content('ISTP')
    end

    it 'personality is ESFJ' do
      create(:personality, :esfj)
      choose('Extrovert', allow_label_click: true)
      choose('Observant', allow_label_click: true)
      choose('Feeling', allow_label_click: true)
      choose('Judging', allow_label_click: true)
      click_button 'Set Personality'
      expect(page).to have_content('ESFJ')
    end

    it 'personality is INFP' do
      create(:personality, :infp)
      choose('Introvert', allow_label_click: true)
      choose('Intuitive', allow_label_click: true)
      choose('Feeling', allow_label_click: true)
      choose('Prospecting', allow_label_click: true)
      click_button 'Set Personality'
      expect(page).to have_content('INFP')
    end

    it 'personality is ESFP' do
      create(:personality, :esfp)
      choose('Extrovert', allow_label_click: true)
      choose('Observant', allow_label_click: true)
      choose('Feeling', allow_label_click: true)
      choose('Prospecting', allow_label_click: true)
      click_button 'Set Personality'
      expect(page).to have_content('ESFP')
    end

    it 'personality is ENFP' do
      create(:personality, :enfp)
      choose('Extrovert', allow_label_click: true)
      choose('Intuitive', allow_label_click: true)
      choose('Feeling', allow_label_click: true)
      choose('Prospecting', allow_label_click: true)
      click_button 'Set Personality'
      expect(page).to have_content('ENFP')
    end

    it 'personality is ESTP' do
      create(:personality, :estp)
      choose('Extrovert', allow_label_click: true)
      choose('Observant', allow_label_click: true)
      choose('Thinking', allow_label_click: true)
      choose('Prospecting', allow_label_click: true)
      click_button 'Set Personality'
      expect(page).to have_content('ESTP')
    end

    it 'personality is ESTJ' do
      create(:personality, :estj)
      choose('Extrovert', allow_label_click: true)
      choose('Observant', allow_label_click: true)
      choose('Thinking', allow_label_click: true)
      choose('Judging', allow_label_click: true)
      click_button 'Set Personality'
      expect(page).to have_content('ESTJ')
    end

    it 'personality is ENTJ' do
      create(:personality, :entj)
      choose('Extrovert', allow_label_click: true)
      choose('Intuitive', allow_label_click: true)
      choose('Thinking', allow_label_click: true)
      choose('Judging', allow_label_click: true)
      click_button 'Set Personality'
      expect(page).to have_content('ENTJ')
    end

    it 'personality is INTP' do
      create(:personality, :intp)
      choose('Introvert', allow_label_click: true)
      choose('Intuitive', allow_label_click: true)
      choose('Thinking', allow_label_click: true)
      choose('Prospecting', allow_label_click: true)
      click_button 'Set Personality'
      expect(page).to have_content('INTP')
    end

    it 'personality is ENTP' do
      create(:personality, :entp)
      choose('Extrovert', allow_label_click: true)
      choose('Intuitive', allow_label_click: true)
      choose('Thinking', allow_label_click: true)
      choose('Prospecting', allow_label_click: true)
      click_button 'Set Personality'
      expect(page).to have_content('ENTP')
    end

    it 'personality is ISFP' do
      create(:personality, :isfp)
      choose('Introvert', allow_label_click: true)
      choose('Observant', allow_label_click: true)
      choose('Feeling', allow_label_click: true)
      choose('Prospecting', allow_label_click: true)
      click_button 'Set Personality'
      expect(page).to have_content('ISFP')
    end
  end
end
