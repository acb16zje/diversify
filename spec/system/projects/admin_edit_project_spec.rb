# frozen_string_literal: true

require 'rails_helper'

describe 'Edit Project > Project', :js, type: :system do
  let(:admin) { create(:admin) }
  let(:project) { create(:project, user: admin, category: create(:category), :private) }

  before do
    sign_in admin
    visit "projects/#{project.id}"
  end

  context 'when project is private' do
    it 'can change to public' do
      expect(page).to have_content("Owned by: #{user.name}")
    end
  end
end
