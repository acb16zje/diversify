# frozen_string_literal: true

require 'rails_helper'

describe NewslettersController do
  let(:user) { create(:user) }

  describe 'authorisations' do
    before { sign_in user }

    it { expect { get newsletter_path }.to be_authorized_to(:index?) }
    # it { expect { get edit_user_path(user) }.to be_authorized_to(:edit?, user) }
  end

end