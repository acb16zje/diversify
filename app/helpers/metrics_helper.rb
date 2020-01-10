# frozen_string_literal: true

# Helper for MetricsController
module MetricsHelper
  GRAPH_CONFIG = {
    Social: { group_by: "properties -> 'type'", time: 'time', average: nil },
    Newsletter: { time: 'created_at', average: nil, group_by: nil },
    Subscription: { group_by: "properties -> 'type'",
                    time: 'time', average: nil },
    Visits: { group_by: "properties -> 'action'", average: nil, time: 'time' },
    'Average Time Spent': { group_by: "properties -> 'pathname'",
                            average: "cast(properties ->> 'time' as float)",
                            time: 'time' },
    Referrers: { group_by: 'referrer', time: 'started_at', average: nil }
  }.freeze

  def config_getter(graph)
    val = (GRAPH_CONFIG.stringify_keys.keys.select { |key| graph.include? key })[0]

    GRAPH_CONFIG.stringify_keys.fetch(
      val, time: 'created_at', average: nil, group_by: nil
    )
  end

  def data_getter(graph)
    case graph
    when /Social/
      [{title: 'Social Media', data: Ahoy::Event.social }]
    when /Reason/
      [{ title: 'Reason', data: NewsletterFeedback.graph }]
    when /Landing Page/
      [{ title: 'Sastifaction', data: LandingFeedback.smiley },
       { title: 'Channel', data: LandingFeedback.channel },
       { title: 'Recommend', data: LandingFeedback.interest }]
    when /by Newsletter/
      [{ title: 'Unsubscription', data: Newsletter.graph }]
    when /Newsletter/
      [{ title: 'Subscription', data: NewsletterSubscription.all },
       { title: 'Unsubscription', data: NewsletterFeedback.all }]
    when /Subscription/
      [{ title: 'Subscription', data: Ahoy::Event.subscriptions }]
    when /Visits/
      [{ title: 'Visit', data: Ahoy::Event.action }]
    when /Average Time Spent/
      [{ title: 'Time Spent',
         data: Ahoy::Event.where(name: 'Time Spent') }]
    when /Referrers/
      [{ title: 'Referrers', data: Ahoy::Visit.all }]
    else
      []
    end
  end

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
  def has_data?(array)
    array.any? { |data| data[:data].any? }
  end

  # set time_constraint to data based on the number of time constraint selected
  def time_constraint(time_column, data)
    date1, date2 = params[:time]
    date1 = DateTime.parse(date1)
    data.each_index do |i|
      datalist = data[i][:data]
      data[i][:data] = if datalist.instance_of? Array
                         custom_date_scope(datalist, date1, date2)
                       elsif !date2.nil?
                         datalist.between_date(time_column, date1,
                                               DateTime.parse(date2))
                       end
    end
  end

  def custom_date_scope(datalist, date1, date2)
    datalist.select do |v|
      v[:created_at].between?(
        date1,
        date2.nil? ? date1 + 1.day : DateTime.parse(date2) + 1.day
      )
    end
  end
end
