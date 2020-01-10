# frozen_string_literal: true

# Mailer class for Newsletter
class NewsletterMailer < ApplicationMailer
  def send_newsletter(emails, newsletter)
    @content = newsletter.content

    mail(to: 'no-reply@sheffield.ac.uk',
         bcc: emails,
         subject: newsletter.title,
         content_type: 'text/html')
  end

  def send_welcome(email)
    mail(to: 'no-reply@sheffield.ac.uk',
         bcc: email,
         subject: 'Welcome to Diversify',
         content_type: 'text/html')
  end
end
