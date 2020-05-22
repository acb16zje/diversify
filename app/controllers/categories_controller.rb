# frozen_string_literal: true

class CategoriesController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    return render_404 unless request.xhr?

    render json: { categories: Category.order(:name).pluck(:name) }
  end
end
