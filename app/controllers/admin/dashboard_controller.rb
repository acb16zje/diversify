# frozen_string_literal: true

class Admin::DashboardController < Admin::BaseController

  def index
    @projects, @public_projects, @private_projects,
    @users, @free_users, @pro_users, @ultimate_users,
    @categories, @skills =
      Project.pluck(
        Arel.sql('COUNT(1),'\
        '(SELECT COUNT(1) FROM projects WHERE visibility = true),'\
        '(SELECT COUNT(1) FROM projects WHERE visibility = false),'\
        '(SELECT COUNT(1) FROM users),'\
        "(SELECT COUNT(1) FROM licenses WHERE plan = 'free'),"\
        "(SELECT COUNT(1) FROM licenses WHERE plan = 'pro'),"\
        "(SELECT COUNT(1) FROM licenses WHERE plan = 'ultimate'),"\
        '(SELECT COUNT(1) FROM categories),'\
        '(SELECT COUNT(1) FROM skills)')
      ).first
  end
end
