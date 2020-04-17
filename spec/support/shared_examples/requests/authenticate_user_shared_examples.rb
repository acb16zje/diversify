# frozen_string_literal: true

# shared_examples here are only responsible for authentication

shared_examples 'accessible to authenticated users' do
  before { sign_in user }

  it_behaves_like 'returns 200 OK'
end

shared_examples 'accessible to unauthenticated users' do
  it_behaves_like 'returns 200 OK'
end

shared_examples 'not accessible to unauthenticated users' do
  it_behaves_like 'redirects to', :new_user_session_path
end
