module MetricsHelper
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
      data[i][:data] = if !date2.nil?
                        data[i][:data].between_date(time,date1, date2)
                      else
                        data[i][:data].on_date(time,date1)
                      end
    end
    data
  end
end