# frozen_string_literal: true

class CategoriesController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    @categories = Category.order(:name).distinct

    respond_to do |format|
      format.html
      format.json { render json: { categories: @categories.pluck(:name) } }
    end
  end
end
