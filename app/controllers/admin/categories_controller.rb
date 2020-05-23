# frozen_string_literal: true

class Admin::CategoriesController < Admin::BaseController
  before_action :set_category, only: %i[update destroy]

  def index
    @categories = Category.select(:id, :name).order(:name)
  end

  def create
    category = Category.new(category_params)

    if category.save
      render json: { category: { id: category.id, name: category.name } }
    else
      render json: { message: category.errors.full_messages.join(' ') }, status: :unprocessable_entity
    end
  end

  def update
    return head :ok if @category.update(category_params)

    render json: { message: @category.errors.full_messages.join(' ') }, status: :unprocessable_entity
  end

  def destroy
    @category.destroy ? head(:ok) : head(:bad_request)
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def set_category
    @category = Category.find(params[:id])
  end
end
