# frozen_string_literal: true

# Controller for newsletter
class NewslettersController < ApplicationController
  layout 'metrics_page'

  def index
    @newsletters = Newsletter.all.decorate
  end

  def new; end

  def create
    newsletter = Newsletter.new(newsletter_params)

    if newsletter.save
      flash[:toast] = {type: 'success', message: 'Newsletter sent'}
      render js: "window.location='#{newsletter_path(newsletter)}'"
    else
      render_json('Send Failed', 422)
    end
  end

  def show
    @newsletter = Newsletter.find_by_id(params[:id])

    return unless request.xhr?

    render json: {
      html: render_to_string('newsletters/_modal.haml', layout: false)
    }
  end

  def subscribers
    @subscribers = NewsletterSubscription.where(subscribed: true).decorate
  end

  def subscribe
    if params.key?(:email)
      email = params[:email]
      if NewsletterSubscription.previously_subscribed.exists?(email: email)
        sub = NewsletterSubscription.find_by_email(email)
        sub.subscribed = true
      else
        sub = NewsletterSubscription.new(email: email, subscribed: true)
      end
      sub.save ? sub_pass_action : sub_fail_action('Subscription Failed')
    else
      sub_fail_action('No Email')
    end
  end

  def unsubscribe
    render layout: false
  end

  def post_unsubscribe
    feedback = NewsletterFeedback.create(unsubscribe_params)

    if feedback.errors.any?
      render_json(feedback.errors.full_messages.join(', '), 422)
    else
      # Prevent Oracle attack on newsletter subscribers list by returning as
      # long as the params syntax are correct
      render_json('Newsletter Unsubscribed! Hope to see you again')
    end
  end

  private

  def newsletter_params
    params.require(:newsletter).permit(:title, :content)
  end

  def unsubscribe_params
    p = params.require(:newsletter_unsubscription).permit(:email, reasons: [])

    {
      newsletter_subscription: NewsletterSubscription.find_by_email(p[:email]),
      reasons: p[:reasons]
    }
  end

  def sub_pass_action
    render_json('Thanks for subscribing')
  end

  def sub_fail_action(message)
    render_json(message, 422)
  end
end
