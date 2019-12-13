# frozen_string_literal: true

# Default active model parent
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
