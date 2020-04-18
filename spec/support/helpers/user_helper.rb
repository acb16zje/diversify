# frozen_string_literal: true

# user support module for RSpec testing
module UserHelper
  def fill_form(email, password)
    fill_in 'user_email', with: email
    fill_in 'user_password', with: password
  end
end
