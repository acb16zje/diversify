# frozen_string_literal: true

require 'rails_helper'
require_relative 'user_helper'

describe 'new Personalities > User', :js, type: :system do
  let(:user) { create(:user) }

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
    it 'is ISTJ' do
      choose('Introvert', allow_label_click: true)
      choose('Observant', allow_label_click: true)
      choose('Thinking', allow_label_click: true)
      choose('Judging', allow_label_click: true)
      click_button 'Set Personality'
      # expect(page).to have_content('ISTJ')
      # expect(page).to have_css('subtitle', text: 'ISTJ')
    end
    #
    # it 'personality is INFJ' do
    #   choose('Introvert', allow_label_click: true)
    #   choose('Intuitive', allow_label_click: true)
    #   choose('Feeling', allow_label_click: true)
    #   choose('Judging', allow_label_click: true)
    #   click_button 'Set Personality'
    #   expect(page).to have_content('INFJ')
    # end
    #
    # it 'personality is INTJ' do
    #   choose('Introvert', allow_label_click: true)
    #   choose('Intuitive', allow_label_click: true)
    #   choose('Thinking', allow_label_click: true)
    #   choose('Judging', allow_label_click: true)
    #   click_button 'Set Personality'
    #   expect(page).to have_content('INTJ')
    # end
    #
    # it 'personality is ENFJ' do
    #   choose('Extrovert', allow_label_click: true)
    #   choose('Intuitive', allow_label_click: true)
    #   choose('Feeling', allow_label_click: true)
    #   choose('Judging', allow_label_click: true)
    #   click_button 'Set Personality'
    #   expect(page).to have_content('ENFJ')
    # end
    #
    # it 'personality is ISTP' do
    #   choose('Introvert', allow_label_click: true)
    #   choose('Observant', allow_label_click: true)
    #   choose('Thinking', allow_label_click: true)
    #   choose('Prospecting', allow_label_click: true)
    #   click_button 'Set Personality'
    #   expect(page).to have_content('ISTP')
    # end
    #
    # it 'personality is ESFJ' do
    #   choose('Extrovert', allow_label_click: true)
    #   choose('Observant', allow_label_click: true)
    #   choose('Feeling', allow_label_click: true)
    #   choose('Judging', allow_label_click: true)
    #   click_button 'Set Personality'
    #   expect(page).to have_content('ESFJ')
    # end
    #
    # it 'personality is INFP' do
    #   choose('Introvert', allow_label_click: true)
    #   choose('Intuitive', allow_label_click: true)
    #   choose('Feeling', allow_label_click: true)
    #   choose('Prospecting', allow_label_click: true)
    #   click_button 'Set Personality'
    #   expect(page).to have_content('INFP')
    # end
    #
    # it 'personality is ESFP' do
    #   choose('Extrovert', allow_label_click: true)
    #   choose('Observant', allow_label_click: true)
    #   choose('Feeling', allow_label_click: true)
    #   choose('Prospecting', allow_label_click: true)
    #   click_button 'Set Personality'
    #   expect(page).to have_content('ESFP')
    # end
    #
    # it 'personality is ENFP' do
    #   choose('Extrovert', allow_label_click: true)
    #   choose('Intuitive', allow_label_click: true)
    #   choose('Feeling', allow_label_click: true)
    #   choose('Prospecting', allow_label_click: true)
    #   click_button 'Set Personality'
    #   expect(page).to have_content('ENFP')
    # end
    #
    # it 'personality is ESTP' do
    #   choose('Extrovert', allow_label_click: true)
    #   choose('Observant', allow_label_click: true)
    #   choose('Thinking', allow_label_click: true)
    #   choose('Prospecting', allow_label_click: true)
    #   click_button 'Set Personality'
    #   expect(page).to have_content('ESTP')
    # end
    #
    # it 'personality is ESTJ' do
    #   choose('Extrovert', allow_label_click: true)
    #   choose('Observant', allow_label_click: true)
    #   choose('Thinking', allow_label_click: true)
    #   choose('Judging', allow_label_click: true)
    #   click_button 'Set Personality'
    #   expect(page).to have_content('ESTJ')
    # end
    #
    # it 'personality is ENTJ' do
    #   choose('Extrovert', allow_label_click: true)
    #   choose('Intuitive', allow_label_click: true)
    #   choose('Thinking', allow_label_click: true)
    #   choose('Judging', allow_label_click: true)
    #   click_button 'Set Personality'
    #   expect(page).to have_content('ENTJ')
    # end
    #
    # it 'personality is INTP' do
    #   choose('Introvert', allow_label_click: true)
    #   choose('Intuitive', allow_label_click: true)
    #   choose('Thinking', allow_label_click: true)
    #   choose('Prospecting', allow_label_click: true)
    #   click_button 'Set Personality'
    #   expect(page).to have_content('INTP')
    # end
    #
    # it 'personality is ISFJ' do
    #   choose('Introvert', allow_label_click: true)
    #   choose('Observant', allow_label_click: true)
    #   choose('Feeling', allow_label_click: true)
    #   choose('Judging', allow_label_click: true)
    #   click_button 'Set Personality'
    #   expect(page).to have_content('ISFJ')
    # end
    #
    # it 'personality is ENTP' do
    #   choose('Extrovert', allow_label_click: true)
    #   choose('Intuitive', allow_label_click: true)
    #   choose('Thinking', allow_label_click: true)
    #   choose('Prospecting', allow_label_click: true)
    #   click_button 'Set Personality'
    #   expect(page).to have_content('ENTP')
    # end
    #
    # it 'personality is ISFP' do
    #   choose('Introvert', allow_label_click: true)
    #   choose('Observant', allow_label_click: true)
    #   choose('Feeling', allow_label_click: true)
    #   choose('Prospecting', allow_label_click: true)
    #   click_button 'Set Personality'
    #   expect(page).to have_content('ISFP')
    # end
  end
end
