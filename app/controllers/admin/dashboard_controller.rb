# frozen_string_literal: true

class Admin::DashboardController < Admin::BaseController
  # rubocop:disable Metrics/MethodLength
  def index
    @counts = Project.pluck(
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
  # rubocop:enable Metrics/MethodLength
end
