# frozen_string_literal: true

module NewsletterHelper
  def subscribe(email_presence = false)
    if email_presence
      fill_in 'email', with: FactoryBot.create(:subscriber).email
    else
      fill_in 'email', with: 'not_presence@mail.com'
    end

    click_button 'Subscribe'
    wait_for_ajax
  end

  def empty_email_subscribe
    page.evaluate_script("document.getElementById('email').name = 'null'")
    page.evaluate_script("document.getElementById('email').type = 'null'")
    page.evaluate_script("document.getElementById('email').required = 'false'")
    fill_in 'null', with: 'qwerty'
    click_button 'Subscribe'
    wait_for_ajax
  end

  def unsubscribe(email_presence = true, reason_presence = true)
    if email_presence
      fill_in 'email', with: FactoryBot.create(:subscriber).email
    else
      fill_in 'email', with: 'not_presence@mail.com'
    end

    check 'The emails are too frequent' if reason_presence

    click_button 'Unsubscribe'
    wait_for_ajax
  end
end
