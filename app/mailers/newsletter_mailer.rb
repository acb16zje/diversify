class NewsletterMailer < ApplicationMailer
  default from: 'Diversify <no-reply@sheffield.ac.uk>'

  def send_newsletter(emails, newsletter)
    @content = newsletter.content

    mail(to: 'no-reply@sheffield.ac.uk', bcc: emails, subject: newsletter.title, content_type: "text/html")
  end
end
