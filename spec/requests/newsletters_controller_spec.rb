
# frozen_string_literal: true

require 'rails_helper'

describe NewslettersController do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:newsletter) { create(:newsletter) }
  let(:sub_user) { create(:user, :newsletter)}

  describe 'authorizations' do
    before { sign_in admin }

    it 'checks authorization to #index' do
      expect { get newsletters_path }.to be_authorized_to(
        :index?, Newsletter.all
      )
    end

    it 'checks authorization to #new' do
      expect { get new_newsletter_path }.to be_authorized_to(
        :new?, Newsletter
      )
    end

    it 'check authorization to #show' do
      expect { get newsletter_path(id: newsletter.id) }.to be_authorized_to(
        :manage?, newsletter
      )
    end

    it 'check authorization to #create' do
      expect { post newsletters_path(
        authenticity_token: Devise.friendly_token,
        newsletter: {
          title: newsletter.title,
          content: newsletter.content
        }
      ) }.to be_authorized_to(
        :create?, Newsletter
      )
    end

    it 'checks authorization to #subscribers' do
      expect { get subscribers_newsletters_path }.to be_authorized_to(
        :subscribers?, Newsletter
      )
    end
  end

  shared_examples 'allows access' do
    it { expect(response).to have_http_status(:ok) }
  end

  shared_examples 'deny access' do
    it { expect(response).to have_http_status(:forbidden) }
  end

  shared_examples 'redirect to login' do
    it { expect(response).to redirect_to new_user_session_path }
  end

  describe 'GET #index' do
    context 'when signed in as admin' do
      before do
        sign_in admin
        get newsletters_path
      end

      it_behaves_like 'allows access'
    end

    context 'when signed in as user' do
      before do
        sign_in user
        get newsletters_path
      end

      it_behaves_like 'deny access'
    end

    context 'when signed out' do
      before { get newsletters_path }

      it_behaves_like 'redirect to login'
    end
  end

  describe 'GET #new' do
    context 'when signed in as admin' do
      before do
        sign_in admin
        get new_newsletter_path
      end

      it_behaves_like 'allows access'
    end

    context 'when signed in as user' do
      before do
        sign_in user
        get new_newsletter_path
      end

      it_behaves_like 'deny access'
    end

    context 'when signed out' do
      before { get new_newsletter_path }

      it_behaves_like 'redirect to login'
    end
  end

  describe 'GET #new' do
    context 'when signed in as admin' do
      before do
        sign_in admin
        get new_newsletter_path
      end

      it_behaves_like 'allows access'
    end

    context 'when signed in as user' do
      before do
        sign_in user
        get new_newsletter_path
      end

      it_behaves_like 'deny access'
    end

    context 'when signed out' do
      before { get new_newsletter_path }

      it_behaves_like 'redirect to login'
    end
  end

  describe 'POST #create' do
    before { sign_in admin }

    context 'with valid inputs' do
      it {
        post newsletters_path(
          authenticity_token: Devise.friendly_token,
          newsletter: {
            title: newsletter.title,
            content: newsletter.content
          }
        )
        expect(response).to have_http_status(:ok)
      }
    end

    context 'with invalid inputs' do
      it {
        post newsletters_path(
          authenticity_token: Devise.friendly_token,
          newsletter: {
            title: '',
            content: newsletter.content
          }
        )
        expect(response).to have_http_status(:unprocessable_entity)
      }
    end
  end

  describe 'GET #show' do
    before { sign_in admin }

    context 'with valid newsletter' do
      it {
        get newsletter_path(newsletter.id)
        expect(response).to have_http_status(:ok)
      }
    end

    context 'with invalid newsletter' do
      it {
        get newsletter_path(0)
        expect(response).to have_http_status(:not_found)
      }
    end
  end

  describe 'GET #subscribers' do
    context 'when signed in as admin' do
      before do
        sign_in admin
        get subscribers_newsletters_path
      end

      it_behaves_like 'allows access'
    end

    context 'when signed in as user' do
      before do
        sign_in user
        get subscribers_newsletters_path
      end

      it_behaves_like 'deny access'
    end

    context 'when signed out' do
      before { get subscribers_newsletters_path }

      it_behaves_like 'redirect to login'
    end
  end

  describe 'POST #subscribe' do
    context 'when valid input' do
      it {
        post subscribe_newsletters_path(email: 'test@email.com')
        expect(response).to have_http_status(:ok)
      }
    end

    context 'when invalid input' do
      it {
        post subscribe_newsletters_path(email: 'invalid input')
        expect(response).to have_http_status(:unprocessable_entity)
      }
    end
  end

  describe 'POST #self_subscribe' do
    context 'when logged in' do
      before { sign_in user }

      it {
        post self_subscribe_newsletters_path
        follow_redirect!
        expect(response.body).to include('Newsletter Subscribed')
      }
    end

    context 'when not logged in' do
      it {
        post self_subscribe_newsletters_path
        expect(response).to redirect_to new_user_session_path
      }
    end
  end

  describe 'GET #unsubscribe' do
    context 'should allow access' do
      before { get unsubscribe_newsletters_path }

      it_behaves_like 'allows access'
    end
  end

  describe 'POST #self_unsubscribe' do
    context 'when logged in' do
      before {
        sign_in sub_user
      }

      it {
        post self_unsubscribe_newsletters_path
        follow_redirect!
        expect(response.body).to include('Newsletter Unsubscribed')
      }
    end

    context 'when not logged in' do
      it {
        post self_unsubscribe_newsletters_path
        expect(response).to redirect_to new_user_session_path
      }
    end
  end

  describe 'POST #post_unsubscribe' do
    context 'with valid input' do
      it {
        post unsubscribe_newsletters_path(
          authenticity_token: Devise.friendly_token,
          newsletter_unsubscription: {
            email: sub_user.email,
            reasons: ['no_longer']
          }
        )
        expect(response).to have_http_status(:ok)
      }
    end

    context 'with invalid input' do
      it {
        post unsubscribe_newsletters_path(
          authenticity_token: Devise.friendly_token,
          newsletter_unsubscription: {
            email: sub_user.email,
            reasons: ['invalid']
          }
        )
        expect(response).to have_http_status(:unprocessable_entity)
      }
    end

    context 'with not subscribed email' do
      it {
        post unsubscribe_newsletters_path(
          authenticity_token: Devise.friendly_token,
          newsletter_unsubscription: {
            email: 'randon@email.com',
            reasons: ['no_longer']
          }
        )
        expect(response).to have_http_status(:ok)
      }
    end
  end
end