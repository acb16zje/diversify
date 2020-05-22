# frozen_string_literal: true

class SkillsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    return render_404 unless request.xhr?

    render json: {
      skills: Skill.joins(:category)
                   .select(:id, :name)
                   .where('categories.name ~* ?', params[:category])
                   .order(:name)
                   .to_json
    }
  end
end
