class NewsletterMailer < ApplicationMailer
  default from: 'no-reply@sheffield.ac.uk'

  def send_newsletter(newsletter)
    @content = newsletter.content

    mail(to: "ngjiahua97@gmail.com", subject: newsletter.title, content_type: "text/html")
  end
end
