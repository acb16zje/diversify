# frozen_string_literal: true

require 'rails_helper'

describe NewsletterSubscriptionDecorator, type: :decorator do
  subject(:subscription) do
    build_stubbed(:newsletter_subscription, created_at: today).decorate
  end

  let(:today) { Time.zone.today }

  it 'localises created_at to d/%m/%y at %l:%M %P' do
    expect(subscription.created_at).to eq I18n.l(today)
  end
end
