# frozen_string_literal: true

# Class for Project policies
class ProjectsQuery
  def self.call(params = {}, relation = Project.all)
    search_params = params.except(:page, :sort, :name).permit(
      :status, :category
    ).delete_if { |_, value| value.blank? }
    relation = search(relation, search_params)
    relation = name(relation, params[:name])
    relation = sort(relation, params[:sort])
    relation
  end

  def self.name(relation, name)
    return relation if name.blank?

    relation.where('name LIKE ?', "%#{name}%")
  end

  def self.sort(relation, sort)
    relation.order(sort_items(sort))
  end

  def self.search(relation, search_params)
    relation.where(search_params)
  end

  def self.sort_items(order)
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
