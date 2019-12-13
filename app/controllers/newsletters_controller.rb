# frozen_string_literal: true

class NewslettersController < ApplicationController
  skip_after_action :track_action
  layout 'metrics_page'

  def index
    @newsletters = Newsletter.all
  end

  def new
    @newsletter = Newsletter.new
  end

  def create
    @newsletter = Newsletter.new(newsletter_params)

    if @newsletter.save
      @emails = NewsletterSubscription.pluck(:email)

      @emails.each_slice(50) do |email|
        NewsletterMailer.send_newsletter(email, @newsletter).deliver_later
      end

      respond_to do |format|
        flash['success'] = 'Newsletter Sent'
        format.js { render js: "window.location='#{newsletters_path.to_s}'" }
      end
    else
      respond_to do |format|
        format.json do
          render json: { message: 'Send Failed',
                         class: flash_class('error') }, status: 200
        end
      end
    end
  end

  def show
    newsletter = Newsletter.where('id = ?', params[:id]).first

    respond_to do |format|
      format.json do
        render json: { title: newsletter.title, content: newsletter.content },
               status: 200
      end
    end
  end

  def unsubscribe
    render layout: false
  end

  def create_unsubscribe
    if params.key?(:email)
      reason = ''
      params.each do |key, value|
        reason += " #{key}" if value == '1'
      end
      feedback = NewsletterFeedback.new(email: params[:email],
                                        reason: reason)
      subscription = NewsletterSubscription.find_by(email: params[:email])
      if reason != '' && feedback.save && !subscription.nil?
        NewsletterSubscription.destroy(subscription.id)
      end
      respond_to do |format|
        format.json do
          render json:
                 if reason != '' && feedback.save && !subscription.nil?
                   { html: 'Newsletter Unsubscribed! Hope to see you again' }
                 else
                   { message: 'Request Failed', class: flash_class('error') }
                 end,
                 status: 200
        end
      end
    end
  end

  def newsletter_params
    params.require(:newsletter).permit(:title, :content)
  end
end
