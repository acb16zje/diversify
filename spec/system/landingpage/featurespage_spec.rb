require 'rails_helper'

describe 'Navigations > Features', :js, type: :system do
  before do
    visit features_pages_path
  end

  it do
    expect(page).to have_content('Hear more from people like you')
  end

end
