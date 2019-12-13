# frozen_string_literal: true

class NewslettersController < ApplicationController
  skip_after_action :track_action
  layout "metrics_page"

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

      respond_to do |format|
        flash["success"] = "Newsletter Sent"
        format.js do
          render js: "window.location='#{newsletters_path}'"
        end
      end
    else
      respond_to do |format|
        format.json do
          render json: {message: "Send Failed", class: flash_class("error")}, status: 200
        end
      end
    end
  end

  def show
    newsletter = Newsletter.where("id = ?", params[:id]).first

    respond_to do |format|
      format.json do
        render json: {title: newsletter.title, content: newsletter.content},
               status: 200
      end
    end
  end

  def unsubscribe
    render layout: false
  end

  def create_unsubscribe
    return unless params.key?(:email)

    reason = ""
    params.each do |key, value|
      reason += " #{key}" if value == "1"
    end
    feedback = NewsletterFeedback.new(email: params[:email], reason: reason)
    subscription = NewsletterSubscription.find_by(email: params[:email])
    json = unsubscribe_json(reason, feedback, subscription)
    respond_to do |format|
      format.json do
        render json: json, status: 200
      end
    end
  end

  private

  def unsubscribe_json(reason, feedback, subscription)
    if reason != "" && feedback.save && !subscription.nil?
      NewsletterSubscription.destroy(subscription.id)
      json = {html: "Newsletter Unsubscribed! Hope to see you again"}
    else
      json = if subscription.nil?
        {message: "This email is not subscribed to the newsletter!",
         class: flash_class("error"),}
      else
        {message: "Please select a reason!", class: flash_class("error")}
      end
    end
    json
  end

  def newsletter_params
    params.require(:newsletter).permit(:title, :content)
  end
end
