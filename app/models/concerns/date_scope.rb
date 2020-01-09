# frozen_string_literal: true

# Date scoping module
# see https://api.rubyonrails.org/classes/ActiveSupport/Concern.html
module DateScope
  extend ActiveSupport::Concern

  included do
    scope :between_date, lambda { |column, start_date, end_date|
      where(column + ' BETWEEN ? AND ?', start_date, end_date.end_of_day)
    }
  end
end
