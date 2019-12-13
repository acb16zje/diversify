# frozen_string_literal: true

# Controller for metrics
class MetricsController < ApplicationController
  skip_after_action :track_action
  layout 'metrics_page'

  def index
    @total_visits_count = Ahoy::Visit.count
    @today_visits = Ahoy::Visit.where(
      started_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day
    ).size
    @total_subscribers = NewsletterSubscription.count

    @subscriptions = [{ title: 'Subscription',
                        data: Ahoy::Event.where(name: 'Clicked pricing link') }]
  end

  def traffic
    @device_count = Ahoy::Visit.all.group(:device_type).count
    @browser_count = Ahoy::Visit.all.group(:browser).count
    @country_count = Ahoy::Visit.all.group(:country).count

    @data = [{ title: 'Referrers', data: Ahoy::Visit.all }]
  end

  def newsletter
    sub = NewsletterSubscription.all
    feedback = NewsletterFeedback.all
    @data = [{ title: 'Subscription', data: sub },
             { title: 'Unsubscription', data: feedback }]
  end

  def update_graph_time
    if params.key?(:graph_name)
      # decide on layout
      layout = decide_layout(params[:graph_name])

      # decide on Data and Grouping
      data, config = data_setter(params[:graph_name])
      # set time constraint to graphs if exist
      if (params[:graph_name].include? 'by Newsletter') && !params[:time].empty?
        date1, date2 = params[:time]
        data = data.select do |v|
          if !date2.nil?
            DateTime.parse(date1) < v[:created_at] &&
              v[:created_at] < DateTime.parse(date2) + 1.days
          else
            DateTime.parse(date1) < v[:created_at] &&
              v[:created_at] < DateTime.parse(date1) + 1.days
          end
        end
      elsif !params[:time].empty?
        data = time_constraint(data)
      end

      if params[:graph_name].include? 'by Newsletter'
        data = [{ title: 'Unsubscription', data: data.collect do |i|
          ["#{i['title']} #{i['created_at'].utc.strftime('%Y-%m-%d')}",
           i['feedback_count']]
        end }]
      end
      puts data
      # Check if there is still valid data, else return "No Data"
      if there_data?(data)
        config[:data] = data
        return_partial('#graph-div', layout, config)
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
        format.json { render json: response, status: 200 }
      end
    else
      respond_to do |format|
        format.json do
          render json: { title: '#graph-div', html: '<p>No Data</p>' },
                 status: 200
        end
      end
    end
  end

  def generate_json_response(title, template, locals)
    { title: title,
      # Renders the ERB partial to a string
      html: render_to_string(
        template: template, # The ERB partial
        formats: :html, # The string format
        layout: false, # Skip the application layout
        locals: locals
      ) } # Pass the model object with errors
  end

  private

  # Helper function to decide layout based on selected graph
  def decide_layout(option)
    case option
    when /Landing Page/
      'metrics/_feedback.haml'
    when /by Date/
      'metrics/_linegraph.haml'
    when /per Page|Newsletter/
      'metrics/_barchart.haml'
    else
      'metrics/_piechart.haml'
    end
  end

  # loops through arrays and check if there is at least one array has data
  def there_data?(array)
    puts array
    array.each do |data|
      return false unless data[:data].present?
    end
    true
  end

  # set time_constraint to data based on the number of time constraint selected
  def time_constraint(data)
    date1, date2 = params[:time]
    data.each_index do |i|
      data[i][:data] = if !date2.nil?
                         data[i][:data].betweenDate(date1, date2)
                       else
                         data[i][:data] = data[i][:data].on_date(date1)
                       end
    end
    data
  end

  # set
  def data_setter(option)
    case option
    when /Reason/
      data = NewsletterFeedback.select(:reason)
      data = [{ title: 'Reason', data: NewsletterFeedback.count_reason(data) }]
      config = { time: nil, average: nil, group_by: nil }
    when /Landing Page/
      data = [{ title: 'Sastifaction', data: LandingFeedback.select(:smiley) },
              { title: 'Channel', data: LandingFeedback.select(:channel) },
              { title: 'Recommend', data: LandingFeedback.select(:interest) }]
      config = { time: nil, average: nil, group_by: nil }
    when /by Newsletter/
      data = Newsletter.find_by_sql('SELECT newsletters.title,
         newsletters.created_at, COUNT(newsletter_feedbacks)
         as feedback_count FROM newsletters JOIN newsletter_feedbacks
         ON newsletter_feedbacks.created_at BETWEEN newsletters.created_at
         AND newsletters.created_at+interval\'7 days\' GROUP BY newsletters.id')
      config = { time: nil, average: nil, group_by: nil }
    when /Newsletter/
      data = [{ title: 'Subscription', data: NewsletterSubscription.all },
              { title: 'Unsubscription', data: NewsletterFeedback.all }]
      config = { time: 'created_at', average: nil, group_by: nil }
    when /Subscription/
      data = [{ title: 'Subscription',
                data: Ahoy::Event.where(name: 'Clicked pricing link') }]
      config = { group_by: "properties -> 'type'", time: 'time', average: nil }
    when /Visits/
      data = [{ title: 'Visit', data: Ahoy::Event.where(name: 'Ran action') }]
      config = { group_by: "properties -> 'action'", average: nil, time: nil }
    when /Average Time Spent/
      data = [{ title: 'Time Spent',
                data: Ahoy::Event.where(name: 'Time Spent') }]
      config = { group_by: "properties -> 'location'",
                 average: "cast(properties ->> 'time' as float)", time: nil }
    when /Referrers/
      data = [{ title: 'Referrers', data: Ahoy::Visit.all }]
      config = { group_by: 'referrer', time: 'started_at', average: nil }
    else
      data = []
      config = []
    end
    [data, config]
  end
end
