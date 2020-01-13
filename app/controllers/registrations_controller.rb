# frozen_string_literal: true

# Subclass of Devise controller
class RegistrationsController < Devise::RegistrationsController
  layout 'devise', only: [:edit]
end
