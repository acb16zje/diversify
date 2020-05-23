# frozen_string_literal: true

class SkillsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    return render_404 unless request.xhr?

    render json: {
      skills: Skill.with_category.where('categories.name ~* ?', params[:category]).to_json
    }
  end
end
