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
    @newsletter = Newsletter.find(params[:id])

    return unless request.xhr?

    content = ActionController::Base.helpers.sanitize(@newsletter.content)
    render json: { title: @newsletter.title, content: content }
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
      { html: 'Newsletter Unsubscribed! Hope to see you again' }
    elsif subscription.nil?
      { message: 'This email is not subscribed to the newsletter',
        class: flash_class('error') }
    else
      { message: 'Please select a reason', class: flash_class('error') }
    end
  end

  def newsletter_params
    params.require(:newsletter).permit(:title, :content)
  end

  def sub_pass_action
    NewsletterMailer.send_welcome(params[:email]).deliver_later
    message = 'Newsletter Subscribed'
    class_card = flash_class('success')

    render json: { message: message, class: class_card }
  end

  def sub_fail_action(message)
    class_card = flash_class('error')
    render json: { message: message, class: class_card }
  end
end
