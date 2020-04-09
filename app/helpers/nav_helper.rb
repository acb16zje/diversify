# frozen_string_literal: true

# Helper for creating navigation links
module NavHelper
  def nav_link_to(name = nil, options = {}, &block)
    classes = [options.delete(:class)&.split(' ')]
    classes << 'is-active' if active_nav_link?(options)

    if block_given?
      link_to(options[:path], class: classes) { capture(&block) + name }
    else
      link_to name, options[:path], class: classes
    end
  end

  def active_nav_link?(options = {})
    # Path params is ignored if controller or action is provided
    if only_path?(options)
      current_path?(options[:path])
    else
      current_controller_and_action?(options)
    end
  end

  private

  def only_path?(options)
    !options[:controller] && !options[:action]
  end

  def current_controller_and_action?(options)
    c = options.delete(:controller)
    a = options.delete(:action)

    if c && a
      # When given both options, make sure BOTH are true
      current_controller?(*c) && current_action?(*a)
    else
      # Otherwise check EITHER option
      current_controller?(*c) || current_action?(*a)
    end
  end
end
