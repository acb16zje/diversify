# frozen_string_literal: true

module ApplicationHelper
  def active?(path)
    request.fullpath == path ? 'is-active' : ''
  end

  def action?(controller, action)
    action.include?(params[:action]) && controller.include?(params[:controller]) ? 'is-active' : ''
  end
end
