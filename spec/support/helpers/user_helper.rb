# frozen_string_literal: true

# user support module for RSpec testing
module UserHelper
  # frozen_string_literal: true

  def fill_password_form(password, password_confirmation)
    fill_in 'user_password', with: password
    fill_in 'user_password_confirmation', with: password_confirmation
  end

  def fill_form(email, password)
    fill_in 'user_email', with: email
    fill_in 'user_password', with: password
  end

end
