# frozen_string_literal: true

require 'rails_helper'

describe 'Team > View team detail', :js, type: :system do
  let(:user) { create(:user) }
  let(:category) { create(:category) }
  let(:project) { create(:project, user: user, category_id: category.id) }
  let(:team) { create(:team, project: project) }

  before do
    team
    sign_in user
    visit "projects/#{project.id}"
  end

  context 'when view team member detail' do
    it do
      find(:xpath, "//p[contains(text(),'#{team.name}')]/span").click
      expect(page).to have_content('Members: 0 / 5')
    end
  end
end
