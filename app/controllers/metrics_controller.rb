class MetricsController < ApplicationController

  skip_after_action :track_action
  layout 'metrics_page'

  def index
    @total_visits_count = Ahoy::Visit.count
    @today_visits = Ahoy::Visit.where(started_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day).size
    @total_subscribers = NewsletterSubscription.count

    @subscriptions = [{title: 'Subscription', data: Ahoy::Event.where(name: "Clicked pricing link")}]
  end

  def traffic
    @device_count = Ahoy::Visit.all.group(:device_type).count
    @browser_count = Ahoy::Visit.all.group(:browser).count
    @country_count = Ahoy::Visit.all.group(:country).count

    @data = [{title: 'Referrers', data: Ahoy::Visit.all}]
  end

  def newsletter
    @data = [{title: 'Subscription', data: NewsletterSubscription.all}, {title: 'Unsubscription', data: NewsletterFeedback.all}]
  end

  def update_graph_time
    if params.has_key?(:graph_name)
      # decide on layout
      layout = decide_layout(params[:graph_name])

      #decide on Data and Grouping
      data, config = data_setter(params[:graph_name])

      # set time constraint to graphs if exist
      if params[:graph_name].include? "by Newsletter"
        if params[:time].length == 2
          data = data.select { |v| DateTime.parse(params[:time][0]) < v[:created_at] && v[:created_at] < DateTime.parse(params[:time][1]) + 1.days }
        elsif params[:time].length == 1
          data = data.select { |v| DateTime.parse(params[:time][0]) < v[:created_at] && v[:created_at] < DateTime.parse(params[:time][0]) + 1.days }
        end
        data = [{title: 'Unsubscription', data: data.collect { |i| ["#{i['title']} #{i['created_at'].utc.strftime('%Y-%m-%d')}", i['feedback_count']] }}]
      else
        data = time_constraint(data)
      end

      #Check if theres is still valid data, else return "No Data"
      if is_there_data?(data)
        config[:data] = data
        return_partial("#graph-div", layout, config)
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
    {:title => title,
     # Renders the ERB partial to a string
     :html => render_to_string(
         :template => template, # The ERB partial
         :formats => :html, # The string format
         :layout => false, # Skip the application layout
         :locals => locals) # Pass the model object with errors
    }
  end

  private

  #Helper function to decide layout based on selected graph
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

  #loops through arrays and check if there is at least one array has data
  def is_there_data?(array)
    for data in array do
      if data[:data].present?
        next
      else
        return false
      end
    end
    true
  end

  # set time_constraint to data based on the number of time constraint selected
  def time_constraint(data)
    data.each_index do |i|
      if params[:time].length() == 2
        data[i][:data] = data[i][:data].betweenDate(params[:time][0], params[:time][1])
      elsif params[:time].length() == 1
        data[i][:data] = data[i][:data].onDate(params[:time][0])
      end
    end
    data
  end

  def data_setter(option)
    case params[:graph_name]
    when /by Newsletter/
      data = Newsletter.find_by_sql("SELECT newsletters.title, newsletters.created_at, COUNT(newsletter_feedbacks)
        as feedback_count FROM newsletters JOIN newsletter_feedbacks
         ON newsletter_feedbacks.created_at BETWEEN newsletters.created_at
        AND newsletters.created_at+interval'7 days' GROUP BY newsletters.id")
      config = {time: nil, average: nil, group_by: nil}
    when /Newsletter/
      data = [{title: 'Subscription', data: NewsletterSubscription.all}, {title: 'Unsubscription', data: NewsletterFeedback.all}]
      config = {time: "created_at", average: nil, group_by: nil}
    when /Subscription/
      data = [{title: 'Subscription', data: Ahoy::Event.where(name: "Clicked pricing link")}]
      config = {group_by: "properties -> 'type'", time: "time", average: nil}
    when /Visits/
      data = [{title: 'Visit', data: Ahoy::Event.where(name: "Ran action")}]
      config = {group_by: "properties -> 'action'", average: nil, time: nil}
    when /Average Time Spent/
      data = [{title: 'Time Spent', data: Ahoy::Event.where(name: "Time Spent")}]
      config = {group_by: "properties -> 'location'", average: "cast(properties ->> 'time' as float)", time: nil}
    when /Referrers/
      data = [{title: 'Referrers', data: Ahoy::Visit.all}]
      config = {group_by: "referrer", time: "started_at", average: nil}
    end
    [data, config]
  end
end

