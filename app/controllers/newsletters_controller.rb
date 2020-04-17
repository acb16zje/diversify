# frozen_string_literal: true

# Controller for newsletter
class NewslettersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[
    subscribe
    unsubscribe
    post_unsubscribe
  ]

  before_action :newsletter_authorize, except: %i[
    subscribe
    unsubscribe
    post_unsubscribe
  ]

  layout 'metrics_page', except: :unsubscribe

  def index
    @newsletters = Newsletter.select(:id, :title, :created_at)
  end

  def create
    newsletter = Newsletter.new(newsletter_params)

    if newsletter.save
      flash[:toast_success] = 'Newsletter sent'
      render js: "window.location = '#{newsletter_path(newsletter)}'"
    else
      render json: { message: 'Send Failed' }, status: :unprocessable_entity
    end
  end

  def show
    @newsletter = Newsletter.find(params[:id])

    return unless request.xhr?

    render json: { html: view_to_html_string('newsletters/_modal') }
  end

  def subscribers
    @subscribers = NewsletterSubscription.where(subscribed: true)
  end

  def subscribe
    if NewsletterSubscription.subscribe(params[:email])
      render json: { message: 'Thanks for subscribing' }
    else
      render json: { message: 'Subscription Failed' },
             status: :unprocessable_entity
    end
  end

  def unsubscribe; end

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
    authorize! with: NewsletterPolicy
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
