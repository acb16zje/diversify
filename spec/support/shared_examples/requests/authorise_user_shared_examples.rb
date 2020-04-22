# frozen_string_literal: true

# Authentication before authorisation,
# hence it is required to check whether user is authenticated or not

shared_examples 'accessible to authorised users for public object' do
  it_behaves_like 'accessible to authenticated users'

  context 'with unauthenticated user' do
    it_behaves_like 'returns 404 Not Found'
  end
end

shared_examples 'not accessible to unauthorised users for public object' do
  context 'with authenticated user' do
    before { sign_in user }

    it_behaves_like 'returns 404 Not Found'
  end

  context 'with unauthenticated user' do
    it_behaves_like 'returns 404 Not Found'
  end
end

shared_examples 'accessible to authorised users for private object' do
  it_behaves_like 'accessible to authenticated users'

  context 'with unauthenticated user' do
    it_behaves_like 'not accessible to unauthenticated users'
  end
end

shared_examples 'not accessible to unauthorised users for private object' do
  context 'with authenticated user' do
    before { sign_in user }

    it_behaves_like 'returns 404 Not Found'
  end

  context 'with unauthenticated user' do
    it_behaves_like 'not accessible to unauthenticated users'
  end
end

shared_examples 'accessible to admin users' do
  before { sign_in admin }

  it_behaves_like 'returns 200 OK'
end

shared_examples 'not accessible to non-admin users' do
  it_behaves_like 'not accessible to unauthenticated users'

  context 'with authenticated non-admin user' do
    before { sign_in user }

    it_behaves_like 'returns 404 Not Found'
  end
end
