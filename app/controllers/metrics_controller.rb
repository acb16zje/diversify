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
    if params.has_key?(:time) && params.has_key?(:graph_name)
      case params[:graph_name]
      when "index-graph-date"
        @subscriptions = Ahoy::Event.where(name: "Clicked pricing link")
        if params[:time].present? && @subscriptions.present?
          @time_constraint_subs = @subscriptions
                            .where(time: DateTime.parse(params[:time][0])..DateTime.parse(params[:time][1]) + 1.days)
          return_partial(@time_constraint_subs,
               %w(#index-pie-div #index-line-div),
            %w(metrics/_piechart.haml metrics/_linegraph.haml))
        end
      else
        head 500
      end
    end
  end

  def return_partial(time_data,title_array, template_array)
    response = []
    title_array.zip(template_array).each do |title, template|
      response.append(generate_json_response(title, template, time_data))
    end
    if time_data.present?
      respond_to do |format|
        format.json { render :json => response, :status => 200 }
      end
    else
      respond_to do |format|
        format.json { render :json => [
            {:title => "#index-pie-div", :html => "<p>No Data</p>"},
            {:title => "#index-line-div", :html => "<p>No Data</p>"}
        ], :status => 200 }
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
