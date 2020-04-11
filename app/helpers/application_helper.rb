# frozen_string_literal: true

# Base helper module
module ApplicationHelper
  
  include Pagy::Frontend

  def current_path?(path)
    request.path == path
  end

  def current_controller?(*args)
    args.any? do |v|
      v.to_s.downcase == controller_name || v.to_s.downcase == controller_path
    end
  end

  def current_action?(*args)
    args.any? { |v| v.to_s.downcase == action_name }
  end
end
