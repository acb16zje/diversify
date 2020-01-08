# frozen_string_literal: true

# Controller for metrics
class MetricsController < ApplicationController
  layout 'metrics_page'

  def index
    @static_data = [
      NewsletterSubscription.subscribed_count,
      Ahoy::Visit.today_count,
      Ahoy::Visit.count
    ]
  end

  def traffic
    @static_data = [
      Ahoy::Visit.group(:device_type).size,
      Ahoy::Visit.group(:browser).size,
      Ahoy::Visit.group(:country).size
    ]
  end

  def update_graph_time
    return head :bad_request unless graph_params

    name = params[:graph_name]

    # decide on layout
    layout = helpers.decide_layout(name)

    # decide on Data and Grouping
    data = helpers.data_getter(name)
    config = helpers.config_getter(name)

    # set time constraint to graphs if exist
    helpers.time_constraint(config[:time], data) unless params[:time].blank?

    extra_processing(name, data)
    config[:data] = data

    # Check if there is still valid data, else return "No Data"
    if helpers.has_data?(data)
      return_partial('graph-div', layout, config)
    else
      return_partial(nil, nil, {})
    end
  end

  def return_partial(id, template, config)
    if config[:data].present?
      render json: {
        id: id,
        html: render_to_string(template, layout: false, locals: config)
      }
    else
      render json: { id: 'graph-div', html: '<p>No Data</p>' }
    end
  end

  private

  def extra_processing(name, data)
    if name.include? 'by Newsletter'
      data[0][:data].collect! do |i|
        ["#{i['title']} #{i['created_at'].utc.strftime('%Y-%m-%d')}",
         i['feedback_count']]
      end
    elsif name.include? 'Reason'
      data[0][:data] = NewsletterFeedback.count_reason(data[0][:data])
    end
  end

  def graph_params
    params.require(:graph_name)
  end
end
