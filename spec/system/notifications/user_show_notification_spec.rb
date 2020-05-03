# frozen_string_literal: true

require 'rails_helper'

describe 'Show Notification > Notification', :js, type: :system do
  let(:user) { create(:user) }
  let(:project) { create(:project) }

  before do
    sign_in user
    create(:invitation, user: user, project: project)
    visit projects_path
    find(:xpath, "//button[@class='button rounded-full bg-gray-200 w-10 h-10']").click
  end

  context 'when there is notification' do
    it 'notify user' do
      expect(page).to have_no_content('No Notifications')
    end
  end
end
