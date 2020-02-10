# frozen_string_literal: true

class Users::Settings::EmailsController < Users::Settings::BaseController
  def show
    render 'users/settings/emails'
  end

  def subscribe
    NewsletterSubscription.subscribe(current_user.email)

    flash[:toast] = { type: 'success', message: ['Newsletter Subscribed'] }
    redirect_to settings_emails_path
  end

  def unsubscribe
    NewsletterSubscription.find_by(email: current_user.email)&.unsubscribe

    flash[:toast] = { type: 'success', message: ['Newsletter Unsubscribed'] }
    redirect_to settings_emails_path
  end
end
