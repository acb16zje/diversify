# frozen_string_literal: true

require 'rails_helper'

describe NewsletterDecorator, type: :decorator do
  subject(:newsletter) { build_stubbed(:newsletter, created_at: today).decorate }

  let(:today) { Time.zone.today.to_datetime }

  it 'localises created_at to d/%m/%y at %l:%M %P' do
    expect(newsletter.created_at).to eq I18n.l(today, format: :compact_12)
  end
end
