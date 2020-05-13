# frozen_string_literal: true

require 'rails_helper'

describe 'New Personalities > User', :js, type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
    visit settings_personality_path
  end

  describe 'personality not setted yet' do
    it 'did not make any change' do
      expect(page).to have_no_content('Current personality')
    end

    it 'try to save without any changes' do
      click_button 'Save changes'
      expect(page).to have_no_content('Current personality')
    end

    it 'try to save with lack of certain option' do
      choose('personality_mind_i', allow_label_click: true)
      click_button 'Save changes'
      expect(page).to have_no_content('Current personality')
    end
  end

  describe 'set personalities' do
    it 'personality is ISFJ' do
      create(:personality, :isfj)
      choose('personality_mind_i', allow_label_click: true)
      choose('personality_energy_s', allow_label_click: true)
      choose('personality_nature_f', allow_label_click: true)
      choose('personality_tactic_j', allow_label_click: true)
      click_button 'Save changes'
      expect(page).to have_content('Defender')
    end

    it 'personality is ISTJ' do
      create(:personality, :istj)
      choose('personality_mind_i', allow_label_click: true)
      choose('personality_energy_s', allow_label_click: true)
      choose('personality_nature_t', allow_label_click: true)
      choose('personality_tactic_j', allow_label_click: true)
      click_button 'Save changes'
      expect(page).to have_content('Logistician')
    end

    it 'personality is INFJ' do
      create(:personality, :infj)
      choose('personality_mind_i', allow_label_click: true)
      choose('personality_energy_n', allow_label_click: true)
      choose('personality_nature_f', allow_label_click: true)
      choose('personality_tactic_j', allow_label_click: true)
      click_button 'Save changes'
      expect(page).to have_content('Advocate')
    end

    it 'personality is INTJ' do
      create(:personality, :intj)
      choose('personality_mind_i', allow_label_click: true)
      choose('personality_energy_n', allow_label_click: true)
      choose('personality_nature_t', allow_label_click: true)
      choose('personality_tactic_j', allow_label_click: true)
      click_button 'Save changes'
      expect(page).to have_content('Architect')
    end

    it 'personality is ENFJ' do
      create(:personality, :enfj)
      choose('personality_mind_e', allow_label_click: true)
      choose('personality_energy_n', allow_label_click: true)
      choose('personality_nature_f', allow_label_click: true)
      choose('personality_tactic_j', allow_label_click: true)
      click_button 'Save changes'
      expect(page).to have_content('Protagonist')
    end

    it 'personality is ISTP' do
      create(:personality, :istp)
      choose('personality_mind_i', allow_label_click: true)
      choose('personality_energy_s', allow_label_click: true)
      choose('personality_nature_t', allow_label_click: true)
      choose('personality_tactic_p', allow_label_click: true)
      click_button 'Save changes'
      expect(page).to have_content('Virtuoso')
    end

    it 'personality is ESFJ' do
      create(:personality, :esfj)
      choose('personality_mind_e', allow_label_click: true)
      choose('personality_energy_s', allow_label_click: true)
      choose('personality_nature_f', allow_label_click: true)
      choose('personality_tactic_j', allow_label_click: true)
      click_button 'Save changes'
      expect(page).to have_content('Consul')
    end

    it 'personality is INFP' do
      create(:personality, :infp)
      choose('personality_mind_i', allow_label_click: true)
      choose('personality_energy_n', allow_label_click: true)
      choose('personality_nature_f', allow_label_click: true)
      choose('personality_tactic_p', allow_label_click: true)
      click_button 'Save changes'
      expect(page).to have_content('Mediator')
    end

    it 'personality is ESFP' do
      create(:personality, :esfp)
      choose('personality_mind_e', allow_label_click: true)
      choose('personality_energy_s', allow_label_click: true)
      choose('personality_nature_f', allow_label_click: true)
      choose('personality_tactic_p', allow_label_click: true)
      click_button 'Save changes'
      expect(page).to have_content('Entertainer')
    end

    it 'personality is ENFP' do
      create(:personality, :enfp)
      choose('personality_mind_e', allow_label_click: true)
      choose('personality_energy_n', allow_label_click: true)
      choose('personality_nature_f', allow_label_click: true)
      choose('personality_tactic_p', allow_label_click: true)
      click_button 'Save changes'
      expect(page).to have_content('Campaigner')
    end

    it 'personality is ESTP' do
      create(:personality, :estp)
      choose('personality_mind_e', allow_label_click: true)
      choose('personality_energy_s', allow_label_click: true)
      choose('personality_nature_t', allow_label_click: true)
      choose('personality_tactic_p', allow_label_click: true)
      click_button 'Save changes'
      expect(page).to have_content('Entrepreneur')
    end

    it 'personality is ESTJ' do
      create(:personality, :estj)
      choose('personality_mind_e', allow_label_click: true)
      choose('personality_energy_s', allow_label_click: true)
      choose('personality_nature_t', allow_label_click: true)
      choose('personality_tactic_j', allow_label_click: true)
      click_button 'Save changes'
      expect(page).to have_content('Executive')
    end

    it 'personality is ENTJ' do
      create(:personality, :entj)
      choose('personality_mind_e', allow_label_click: true)
      choose('personality_energy_n', allow_label_click: true)
      choose('personality_nature_t', allow_label_click: true)
      choose('personality_tactic_j', allow_label_click: true)
      click_button 'Save changes'
      expect(page).to have_content('Commander')
    end

    it 'personality is INTP' do
      create(:personality, :intp)
      choose('personality_mind_i', allow_label_click: true)
      choose('personality_energy_n', allow_label_click: true)
      choose('personality_nature_t', allow_label_click: true)
      choose('personality_tactic_p', allow_label_click: true)
      click_button 'Save changes'
      expect(page).to have_content('Logician')
    end

    it 'personality is ENTP' do
      create(:personality, :entp)
      choose('personality_mind_e', allow_label_click: true)
      choose('personality_energy_n', allow_label_click: true)
      choose('personality_nature_t', allow_label_click: true)
      choose('personality_tactic_p', allow_label_click: true)
      click_button 'Save changes'
      expect(page).to have_content('Debater')
    end

    it 'personality is ISFP' do
      create(:personality, :isfp)
      choose('personality_mind_i', allow_label_click: true)
      choose('personality_energy_s', allow_label_click: true)
      choose('personality_nature_f', allow_label_click: true)
      choose('personality_tactic_p', allow_label_click: true)
      click_button 'Save changes'
      expect(page).to have_content('Adventurer')
    end
  end
end
