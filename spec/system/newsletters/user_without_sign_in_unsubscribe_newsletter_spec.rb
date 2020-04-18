# frozen_string_literal: true

require 'rails_helper'

describe 'Email > Unsubscribe newsletter', :js, type: :system do
  before { visit unsubscribe_newsletters_path }

  it 'can unsubscribe from the newsletter' do
    fill_in 'newsletter_unsubscription_email',
            with: create(:newsletter_subscription).email
    check 'The emails are too frequent'
    click_link_or_button 'Unsubscribe'
    expect(page).to have_content('Newsletter Unsubscribed! Hope to see you again')
  end

  it 'check subscription presence constraint' do
    fill_in 'newsletter_unsubscription_email', with: 'not_presence@mail.com'
    check 'The emails are too frequent'
    click_link_or_button 'Unsubscribe'
    expect(page).to have_content('Newsletter Unsubscribed! Hope to see you again')
  end

  it 'invalid email address' do
    fill_in 'newsletter_unsubscription_email', with: 'invalid'
    check 'The emails are too frequent'
    click_link_or_button 'Unsubscribe'
    expect(page).to have_no_content('Newsletter Unsubscribed! Hope to see you again')
  end

  it 'check reason presence constraint' do
    fill_in 'newsletter_unsubscription_email',
            with: create(:newsletter_subscription).email
    click_link_or_button 'Unsubscribe'
    expect(page).to have_content('Reasons is not included in the list')
  end
end
