# frozen_string_literal: true

require 'rails_helper'

describe 'Team > View team member detail', :js, type: :system do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }

  before do
    sign_in user
    visit "projects/#{project.id}"
  end

  context 'when view team member detail' do
    it do
      click_link user.name
      expect(page).to have_content('Profile')
    end
  end
end
