class MetricsController < ApplicationController

  layout 'metrics_page'

  def index
    @total_visits = Ahoy::Visit.all
    if !@total_visits.present?
      @total_visits_count = @total_visits.length
    else
      @total_visits_count = 0
    end

    @today_visits = Ahoy::Visit.where(started_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).length
    if !@today_visits.present?
      @today_visits = 0
    end

    @subscriptions = Ahoy::Event.where(name: "Clicked pricing link")
      # if @subscriptions.present?
      #   @free_subs_count = @subscriptions.where("properties -> 'type' ? :type", type: 'Free')
      #   @pro_subs_count = @subscriptions.where("properties -> 'type' ? :type", type: 'Pro')
      #   @enterprise_subs_count = @subscriptions.where("properties -> 'type' ? :type", type: 'Enterprise')
      # end
  end

end
