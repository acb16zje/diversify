class MetricsController < ApplicationController

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

    @subscriptions = Ahoy::Event.where(name: "Clicked pricing link")
  end

  def traffic
    @device_count = Ahoy::Visit.all.group(:device_type).count
    @browser_count = Ahoy::Visit.all.group(:browser).count
    @country_count = Ahoy::Visit.all.group(:country).count
  end

  def update_graph_time
    if params.has_key?(:graph_name)
      case params[:graph_name]
      when "Subscription Ratio"
        @data = Ahoy::Event.where(name: "Clicked pricing link")
        @id = "#graph-div"
        @layout = "metrics/_piechart.haml"
      when "Subscriptions by Date"
        @data = Ahoy::Event.where(name: "Clicked pricing link")
        @id = "#graph-div"
        @layout = "metrics/_linegraph.haml"
      end
      if @data.present? && params[:time].length() == 2
        @data = @data.where(time: DateTime.parse(params[:time][0])..DateTime.parse(params[:time][1]) + 1.days)
      elsif @data.present? && params[:time].length() == 1
        @data = @data.where(time: DateTime.parse(params[:time]))
      end
      if @data.present?
        return_partial(@data, @id, @layout)
      else
        return_partial(nil, @id, @layout)
      end
    else
      head 500
    end
  end

  def return_partial(time_data, id, layout)
    print("time data: #{time_data.present?}")
    if time_data.present?
      response = generate_json_response(id, layout, time_data)
      respond_to do |format|
        format.json { render :json => response, :status => 200 }
      end
    else
      print("HELLO PLS REPLY")
      respond_to do |format|
        format.json { render :json => {:title => "#graph-div", :html => "<p>No Data</p>"},
                             :status => 200 }
      end
    end
  end

  def generate_json_response(title, template, data)
    json = {:title => title,
            # Renders the ERB partial to a string
            :html => render_to_string(
                :template => template, # The ERB partial
                :formats => :html, # The string format
                :layout => false, # Skip the application layout
                :locals => {data: data}) # Pass the model object with errors
    }
    return json
  end
end
