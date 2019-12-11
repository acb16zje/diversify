class PagesController < ApplicationController

  layout 'landing_page'
  skip_authorization_check

  def home
    @current_nav_identifier = :home
  end
  
  #Function to track subscriptions
  #should be changed once proper subscription system has been completed
  def newsletter
    if params.has_key?(:type)
      ahoy.track "Clicked pricing link", type: params[:type]
    end
  end

  def newsletter_subscriptions
    # if params.has_key?(:email)
    #   @newsletter_subscription = NewsletterSubscription.new(date_subscribed: Time.now(), email: params[:email])
    #   if @newsletter_subscription.save
    redirect_to(root_path, flash: {success: 'Newsletter Subscribed!'}) and return
    return
      # end
    #   else
    #     flash.now['error'] = 'Subscription Failed.'
    #     render 'newsletter'
    #   end
    # else
    #   flash.now['error'] = 'Subscription Failed.'
    #   render 'newsletter'
    # end
  end

  #Function to track time spent in a page
  def track_time

    if params.has_key?(:time) && params.has_key?(:location)
      unless (params[:location].include? "metrics") || (params[:location].include? "newsletters")
        time = params[:time]
        ahoy.track "Time Spent", time_spent: time.to_f.round / 1000, location: params[:location]
      end
      render :json => {}
    else
      head 500
    end
  end

end
