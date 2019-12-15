# frozen_string_literal: true

# Controller for newsletter
class NewslettersController < ApplicationController
  skip_after_action :track_action
  skip_before_action :track_ahoy_visit,
                     only: %i[index create new show subscribers]
  layout 'metrics_page'

  def index
    @newsletters = Newsletter.all
  end

  def new
    @newsletter = Newsletter.new
  end

  def create
    newsletter = Newsletter.new(newsletter_params)

    if newsletter.save
      NewsletterSubscription.delay.send_newsletter(newsletter)
      flash['success'] = 'Newsletter Sent'
      render js: "window.location='#{newsletters_path}'"
    else
      render json: { message: 'Send Failed', class: flash_class('error') }
    end
  end

  def show
    unless request.xhr?
      render 'errors/error_404'
      return
    end

    newsletter = Newsletter.where('id = ?', params[:id]).first

    render json: { title: newsletter.title, content: newsletter.content }
  end

  def subscribe
    if params.key?(:email)
      if NewsletterSubscription.where(subscribed: false).exists?(
        email: params[:email]
      )
        newsletter_subscription =
          NewsletterSubscription.where(email: params[:email]).first
        newsletter_subscription.subscribed = true
      else
        newsletter_subscription =
          NewsletterSubscription.new(
            date_subscribed: Time.now, email: params[:email], subscribed: true
          )
      end

      if newsletter_subscription.save
        subscribe_success_action
      else
        subscribe_failure_action('Subscription Failed')
      end
    else
      subscribe_failure_action('No Email')
    end
  end

  def unsubscribe
    render layout: false
  end

  def create_unsubscribe
    return unless params.key?(:email)

    reason = ''
    params.each { |key, value| reason += " #{key}" if value == '1' }
    feedback = NewsletterFeedback.new(email: params[:email], reason: reason)
    subscription = NewsletterSubscription.find_by(email: params[:email])
    render json: unsubscribe_json(reason, feedback, subscription)
  end

  def subscribers
    @subscribers = NewsletterSubscription.where(subscribed: true)
  end

  private

  def unsubscribe_json(reason, feedback, subscription)
    if reason != '' && !subscription.nil? && feedback.save
      subscription.update(subscribed: false)
      json = { html: 'Newsletter Unsubscribed! Hope to see you again' }
    else
      json =
        if subscription.nil?
          {
            message: 'This email is not subscribed to the newsletter',
            class: flash_class('error')
          }
        else
          { message: 'Please select a reason', class: flash_class('error') }
        end
    end
    json
  end

  def newsletter_params
    params.require(:newsletter).permit(:title, :content)
  end

  def subscribe_success_action
    NewsletterMailer.send_welcome(params[:email]).deliver_now
    message = 'Newsletter Subscribed'
    class_card = flash_class('success')

    render json: { message: message, class: class_card }
  end

  def subscribe_failure_action(message)
    class_card = flash_class('error')
    render json: { message: message, class: class_card }
  end
end
