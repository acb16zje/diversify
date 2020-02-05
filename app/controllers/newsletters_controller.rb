# frozen_string_literal: true

# Controller for newsletter
class NewslettersController < ApplicationController

  skip_before_action :authenticate_user!, only: %i[
    subscribe
    unsubscribe
    post_unsubscribe
  ]

  layout 'metrics_page'

  def index
    @newsletters = Newsletter.select(:title, :created_at)
    authorize! @newsletters
  end

  def new
    authorize!
  end

  def create
    newsletter = Newsletter.new(newsletter_params)
    authorize!

    if newsletter.save
      flash[:toast] = { type: 'success', message: ['Newsletter sent'] }
      render js: "window.location = '#{newsletter_path(newsletter)}'"
    else
      render json: { message: 'Send Failed' }, status: :unprocessable_entity
    end
  end

  def show
    @newsletter = Newsletter.find(params[:id])
    authorize! @newsletter

    return unless request.xhr?

    render json: {
      html: render_to_string('newsletters/_modal.haml', layout: false)
    }
  end

  def subscribers
    @subscribers = NewsletterSubscription.where(subscribed: true)
    authorize!
  end

  def subscribe
    if prepare_subscription(params[:email])
      render json: { message: 'Thanks for subscribing' }
    else
      render json: { message: 'Subscription Failed' },
             status: :unprocessable_entity
    end
  end

  def self_subscribe
    flash[:toast] = if prepare_subscription(current_user.email)
                      { type: 'success', message: ['Newsletter Subscribed'] }
                    else
                      { type: 'error', message: ['Subscription Failed'] }
                    end

    redirect_to settings_users_path
  end

  def unsubscribe
    render layout: false
  end

  def self_unsubscribe
    flash[:toast] = if NewsletterSubscription.find_by(email: current_user.email)
                         &.unsubscribe
                      { type: 'success', message: ['Newsletter Unsubscribed'] }
                    else
                      { type: 'error', message: ['Unsubscription Failed'] }
                    end

    redirect_to settings_users_path
  end

  def post_unsubscribe
    feedback = NewsletterFeedback.create(unsubscribe_params)

    if feedback.errors.any?
      render json: { message: feedback.errors.full_messages.join(', ') },
             status: :unprocessable_entity
    else
      # Prevent Oracle attack on newsletter subscribers list by returning as
      # long as the params syntax are correct
      render json: { message: 'Newsletter Unsubscribed! Hope to see you again' }
    end
  end

  private

  def newsletter_authorize
    authorize! current_user, with: NewsletterPolicy
  end

  def prepare_subscription(email)
    sub = NewsletterSubscription.where(email: email).first_or_initialize
    sub.subscribed = true
    sub.save
  end

  def newsletter_params
    params.require(:newsletter).permit(:title, :content)
  end

  def unsubscribe_params
    p = params.require(:newsletter_unsubscription).permit(:email, reasons: [])

    {
      newsletter_subscription: NewsletterSubscription.find_by(email: p[:email]),
      reasons: p[:reasons]
    }
  end
end
