# frozen_string_literal: true

# Do not do authentication or authorisation here
# shared_examples here are only responsible for request-response

shared_examples 'returns 200 OK' do
  before { request }

  it { expect(response).to have_http_status(:ok) }
end

shared_examples 'returns 204 No Content' do
  before { request }

  it { expect(response).to have_http_status(:no_content) }
end

shared_examples 'returns 400 Bad Request' do
  before { request }

  it { expect(response).to have_http_status(:bad_request) }
end

shared_examples 'returns 401 Unauthorized' do
  before { request }

  it { expect(response).to have_http_status(:unauthorized) }
end

shared_examples 'returns 403 Forbidden' do
  before { request }

  it { expect(response).to have_http_status(:forbidden) }
end

shared_examples 'returns 404 Not Found' do
  before { request }

  it { expect(response).to have_http_status(:not_found) }
end

shared_examples 'returns 422 Unprocessable Entity' do
  before { request }

  it { expect(response).to have_http_status(:unprocessable_entity) }
end

shared_examples 'returns JSON response' do
  before { request }

  it { expect(response.content_type).to include('application/json') }
end

shared_examples 'redirects to' do |path|
  before { request }

  it { expect(response).to redirect_to(send(path)) }
end
