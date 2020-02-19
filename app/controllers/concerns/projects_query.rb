# frozen_string_literal: true

# Class for Project query
module ProjectsQuery
  def call(params = {}, relation = Project.all)
    relation = Project.where(user: current_user) if params[:type] == 'owned'

    search_params = params.except(:page, :sort, :name, :type).permit(
      :status, :category
    ).delete_if { |_, value| value.blank? }
    relation = search(relation, search_params)
    relation = name(relation, params[:name])
    sort(relation, params[:sort])
  end

  def name(relation, name)
    return relation if name.blank?

    relation.where('name LIKE ?', "%#{name}%")
  end

  def sort(relation, sort)
    relation.order(sort_items(sort))
  end

  def search(relation, search_params)
    relation.where(search_params)
  end

  def sort_items(order)
    case order
    when 'name_desc'
      'name desc'
    when 'date_asc'
      'created_at asc'
    when 'date_desc'
      'created_at desc'
    else
      'name asc'
    end
  end
end
