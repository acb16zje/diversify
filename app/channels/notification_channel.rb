class NotificationChannel < ApplicationCable::Channel
  def subscribed
    puts "COME ON SUBSCRIBED"
    stream_for current_user
  end

  def unsubscribed
    puts "COME ON UNSUBSCRIBED"
    # Any cleanup needed when channel is unsubscribed
  end
end
