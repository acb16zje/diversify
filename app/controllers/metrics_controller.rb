# frozen_string_literal: true

# Controller for metrics
class MetricsController < ApplicationController
  skip_after_action :track_action
  skip_before_action :track_ahoy_visit

  layout 'metrics_page'

  def index
    @static_data = [
      NewsletterSubscription.where(subscribed: true).count,
      Ahoy::Visit.today_count,
      Ahoy::Visit.count
    ]
  end

  def traffic
    @static_data = [
      Ahoy::Visit.all.group(:device_type).count,
      Ahoy::Visit.all.group(:browser).count,
      Ahoy::Visit.all.group(:country).count
    ]
  end

  def update_graph_time
    if graph_params
      name = params[:graph_name]

      # decide on layout
      layout = helpers.decide_layout(name)

      # decide on Data and Grouping
      data, config = setter(name)

      puts "PRE DATA #{data}"
      # set time constraint to graphs if exist
      helpers.time_constraint(config[:time], data) unless params[:time].empty?
      puts "DATA #{data}"
      extra_processing(name, data)
      config[:data] = data

      
      # Check if there is still valid data, else return "No Data"
      if helpers.has_data?(data)
        return_partial('#graph-div', layout, config)
      else
        return_partial(nil, nil, {})
      end
    else
      head 500
    end
  end

  def return_partial(id, layout, locals)
    if locals[:data].present?
      render json: generate_json_response(id, layout, locals)
    else
      render json: { title: '#graph-div', html: '<p>No Data</p>' }
    end
  end

  def generate_json_response(title, template, locals)
    {
      title: title,
      html:
        render_to_string(
          # Renders the ERB partial to a string
          template: template,
          # The ERB partial
          formats: :html,
          # The string format
          layout: false,
          # Skip the application layout
          locals: locals
        )
    } # Pass the model object with errors
  end

  # set
  def setter(graph)
    [helpers.data_setter(graph), helpers.config_setter(graph)]
  end

  private

  def extra_processing(name, data)
    datalist = data[0][:data]
    if name.include? 'by Newsletter'
      datalist = datalist.collect do |i|
        ["#{i['title']} #{i['created_at'].utc.strftime('%Y-%m-%d')}",
         i['feedback_count']]
      end
    elsif name.include? 'Reason'
      datalist = NewsletterFeedback.count_reason(datalist)
    end
    data[0][:data] = datalist
  end

  def graph_params
    params.require(:metric)
  end
end