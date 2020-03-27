# frozen_string_literal: true

module NewsletterHelper
  def send_newsletter(has_content = true)
    fill_in 'newsletter_title', with: 'random title'
    find('trix-editor').click.set('random text') if has_content
    click_button 'Send newsletter'
  end

  def subscribe(email_presence = false, unsubscribed = false)
    subscriber = create(:newsletter_subscription, subscribed: !unsubscribed)
    fill_in 'email', with: email_presence ? subscriber.email : 'null@null.com'
    click_button 'Subscribe'
  end

  def empty_email_subscribe
    page.evaluate_script("document.getElementById('email').name = 'null'")
    page.evaluate_script("document.getElementById('email').type = 'null'")
    page.evaluate_script("document.getElementById('email').required = 'false'")
    fill_in 'null', with: 'qwerty'
    click_button 'Subscribe'
  end

  def unsubscribe(email_presence = true, reason_presence = true)
    fill_in 'newsletter_unsubscription_email',
            with: email_presence ? create(:newsletter_subscription).email : 'not_presence@mail.com'

    check 'The emails are too frequent' if reason_presence

    click_link_or_button 'Unsubscribe'
  end
end
