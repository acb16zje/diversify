# frozen_string_literal: true

class Users::Settings::EmailsController < Users::Settings::BaseController
  def show
    render 'users/settings/emails'
  end

  def subscribe
    NewsletterSubscription.subscribe(current_user.email)

    flash[:toast_success] = 'Newsletter Subscribed'
    redirect_to settings_emails_path
  end

  def unsubscribe
    NewsletterSubscription.find_by(email: current_user.email)&.unsubscribe

    flash[:toast_success] = 'Newsletter Unsubscribed'
    redirect_to settings_emails_path
  end
end
