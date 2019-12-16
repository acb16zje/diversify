module MetricsHelper

  GRAPH_CONFIG = {
    "Newsletter"=> { time: 'created_at', average: nil, group_by: nil },
    "Subscription"=> { group_by: "properties -> 'type'", time: 'time', average: nil },
    "Visits"=> { group_by: "properties -> 'action'", average: nil, time: 'time' },
    "Average Time Spent"=> { group_by: "properties -> 'pathname'", average: "cast(properties ->> 'time' as float)", time: 'time' },
    "Referrers"=> { group_by: 'referrer', time: 'started_at', average: nil }
  }

  def config_setter(option)
    val = GRAPH_CONFIG.keys.select {|key| option.include? key }
    GRAPH_CONFIG.fetch(val[0], { time: 'created_at', average: nil, group_by: nil })
  end

  def data_setter(option)

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
  def there_data?(array)
    array.each do |data|
      return true if data[:data].any?
    end
    false
  end

  # set time_constraint to data based on the number of time constraint selected
  def time_constraint(time, data)
    date1, date2 = params[:time]
    data.each_index do |i|
      if data[i][:data].instance_of? Array
        data[i][:data] = custom_date_scope(data[i][:data])
      else
        data[i][:data] = if !date2.nil?
          data[i][:data].between_date(time,date1, date2)
        else
          data[i][:data].on_date(time,date1)
        end
      end
    end
    data
  end

  def custom_date_scope(data)
    data.select do |v|
      if !date2.nil?
        DateTime.parse(date1) < v[:created_at] &&
          v[:created_at] < DateTime.parse(date2) + 1.days
      else
        DateTime.parse(date1) < v[:created_at] &&
          v[:created_at] < DateTime.parse(date1) + 1.days
      end
    end
  end
end