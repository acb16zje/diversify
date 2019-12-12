class MetricsController < ApplicationController

  skip_after_action :track_action
  layout 'metrics_page'

  def index
    @total_visits = Ahoy::Visit.all
    if @total_visits.present?
      @total_visits_count = @total_visits.length
    else
      @total_visits_count = 0
    end

    @today_visits = Ahoy::Visit.where(started_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).length
    unless @today_visits.present?
      @today_visits = 0
    end

    @subscriptions = [{title:'Subscription',data:Ahoy::Event.where(name: "Clicked pricing link")}]
  end

  def traffic
    @device_count = Ahoy::Visit.all.group(:device_type).count
    @browser_count = Ahoy::Visit.all.group(:browser).count
    @country_count = Ahoy::Visit.all.group(:country).count

    @data = [{title:'Referrers',data:Ahoy::Visit.all}]
  end

  def newsletter
    @data = [{title:'Subscription',data: NewsletterSubscription.all},{title:'Unsubscription', data: NewsletterFeedback.all}]
  end

  def update_graph_time
    if params.has_key?(:graph_name)
      id = "#graph-div"

      # decide on layout
      layout = decide_layout(params[:graph_name])
      
      #decide on Data and Grouping
      case params[:graph_name]
      when /by Newsletter/
        time_data = ActiveRecord::Base.connection.execute("SELECT newsletters.title, newsletters.created_at, COUNT(newsletter_feedbacks)
        as feedback_count FROM newsletters JOIN newsletter_feedbacks ON newsletter_feedbacks.created_at BETWEEN newsletters.created_at
        AND newsletters.created_at+interval'7 days' GROUP BY newsletters.id")
        data = [{title: 'Unsubscription', data: time_data.collect{|i| ["#{i['title']} #{i['created_at'].utc.strftime('%Y-%m-%d')}",i['feedback_count']]}}]
      when /Newsletter/
        data = [{title:'Subscription',data: NewsletterSubscription.all},{title:'Unsubscription', data: NewsletterFeedback.all}]
        time = "created_at"
      when /Subscription/
        data = [{title:'Subscription',data: Ahoy::Event.where(name: "Clicked pricing link")}]
        group = "properties -> 'type'"
        time = "time"
      when /Visits/
        data = [{title:'Visit',data:Ahoy::Event.where(name: "Ran action")}]
        group = "properties -> 'action'"
      when /Average Time Spent/
        data = [{title:'Time Spent',data: Ahoy::Event.where(name: "Time Spent")}]
        group = "properties -> 'location'"
        average = "cast(properties ->> 'time' as float)"
      when /Referrers/
        data = [{title:'Referrers',data:Ahoy::Visit.all}]
        group = "referrer"
        time = "started_at"
      end

      # set time constraint to graphs if exist
      data.each_index do |i|
        if params[:time].length() == 2
          data[i][:data] = data[i][:data].betweenDate(params[:time][0],params[:time][1])
        elsif params[:time].length() == 1
          data[i][:data] = data[i][:data].onDate(params[:time][0])
        end
      end

      #Check if theres is still valid data, else return "No Data"
      if is_there_data?(data)
        return_partial(id, layout, {data: data, group_by: group, time: time, average: average})
      else
        return_partial(nil, nil, {})
      end
    else
      head 500
    end
  end

  # def return_partial(time_data, id, layout, group, time)
  def return_partial(id, layout, locals)
    if locals[:data].present?
      response = generate_json_response(id, layout, locals)
      respond_to do |format|
        format.json { render :json => response, :status => 200 }
      end
    else
      respond_to do |format|
        format.json { render :json => {:title => "#graph-div", :html => "<p>No Data</p>"},
                             :status => 200 }
      end
    end
  end

  def generate_json_response(title, template, locals)
    json = {:title => title,
            # Renders the ERB partial to a string
            :html => render_to_string(
                :template => template, # The ERB partial
                :formats => :html, # The string format
                :layout => false, # Skip the application layout
                :locals => locals) # Pass the model object with errors
    }
    return json
  end

  private
    def decide_layout(option)
      case option
      when /by Date/
        return "metrics/_linegraph.haml"
      when /per Page|Newsletter/
        return "metrics/_barchart.haml"
      else
        return "metrics/_piechart.haml"
      end
    end

    def is_there_data?(array)
      for data in array do 
        if data.present?
          next
        else
          return false
        end
      end
      return true
    end
end
