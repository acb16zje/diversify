# frozen_string_literal: true

module NewsletterHelper
  def fill_in_ckeditor(locator, opts)
    content = opts.fetch(:with).to_json # convert to a safe javascript string
    page.execute_script <<-SCRIPT
    CKEDITOR.instances['#{locator}'].setData(#{content});
    $('textarea##{locator}').text(#{content});
    SCRIPT
  end

  def send_newsletter(has_content = true)
    fill_in 'newsletter_title', with: 'random title'

    fill_in_ckeditor 'newsletter_content', with: 'random content' if has_content

    click_button 'Send newsletter'
  end

  def subscribe(email_presence = false, unsubscribed = false)
    subscriber =
      if unsubscribed
        create(:newsletter_subscription, :unsubscribed)
      else
        create(:newsletter_subscription)
      end

    fill_in 'email', with: email_presence ? subscriber.email : 'null@null.com'

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
      fill_in 'email', with: create(:subscriber).email
    else
      fill_in 'email', with: 'not_presence@mail.com'
    end

    check 'The emails are too frequent' if reason_presence

    click_button 'Unsubscribe'
    wait_for_ajax
  end
end
