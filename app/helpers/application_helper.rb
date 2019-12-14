module ApplicationHelper

  def is_active?(path)
    request.fullpath == path ? 'is-active' : ''
  end

  def action?(controller,action)
   action.include?(params[:action]) && controller.include?(params[:controller]) ? 'is-active' : ''
  end
end
