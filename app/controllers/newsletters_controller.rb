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
        flash['success'] = "Newsletter Sent"
        format.js { render js: "window.location='#{newsletters_path.to_s}'" }
      end
    else
      respond_to do |format|
        format.json { render json: {message: 'Send Failed', class: flash_class('error')}, status: 200 }
      end
    end
  end

  def show
    newsletter = Newsletter.where('id = ?', params[:id]).first

    respond_to do |format|
      format.json { render json: {title: newsletter.title, content: newsletter.content}, status: 200 }
    end
  end

  def unsubscribe
    render layout: false
  end

  def newsletter_params
    params.require(:newsletter).permit(:title, :content)
  end
end
