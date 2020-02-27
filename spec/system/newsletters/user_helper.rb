# frozen_string_literal: true

def fill_form(email, password)
  fill_in 'user_email', with: email
  fill_in 'user_password', with: password
end
