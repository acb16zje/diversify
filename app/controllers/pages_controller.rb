class PagesController < ApplicationController

  layout 'landing_page'
  skip_authorization_check

  def home
    @current_nav_identifier = :home
  end

  #Function to track subscriptions
  #should be changed once proper subscription system has been completed
  def newsletter
    @newsletter_subscription = NewsletterSubscription.new
    if params.key?(:type)
      ahoy.track "Clicked pricing link", type: params[:type]
    end
  end

  def newsletter_subscriptions
    if params.key?(:email)
      @newsletter_subscription = NewsletterSubscription.new(date_subscribed: Time.now(), email: params[:email])
      if @newsletter_subscription.save
        NewsletterMailer.send_welcome(params[:email]).deliver_now
        @message = 'Newsletter Subscribed!'
        @class = flash_class('success')
      else
        @message = 'Subscription Failed'
        @class = flash_class('error')
      end
    else
      @message = 'No Email'
      @class = flash_class('error')
    end
    respond_to do |format|
      format.json { render :json => {message: @message, class: @class}, :status => 200 }
    end
  end

  #Function to track time spent in a page
  def track_time
    if params.key?(:time) && params.key?(:location)
      if is_valid_location?(params[:location])
        time = params[:time]
        ahoy.track "Time Spent", time_spent: millisec_to_sec(time), location: params[:location]
      end
      render :json => {}
    else
      head 500
    end
  end

  private

  def millisec_to_sec(time)
    return time.to_f.round / 1000
  end

  def is_valid_location?(location)
    return !(location.include? "metrics") && !(location.include? "newsletters")
  end
end
