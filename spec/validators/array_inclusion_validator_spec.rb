# frozen_string_literal: true

require 'rails_helper'

describe ArrayInclusionValidator, type: :validator do
  subject { validator.validate_each(dummy_model, :attr, value) }

  let(:dummy_model) do
    instance_double('Dummy',
                    attr: [1, 2, 3],
                    errors: ActiveModel::Errors.new(self))
  end

  let(:validator) do
    described_class.new(attributes: [:attr], in: (1..10))
  end

  shared_examples 'returns errors' do
    before { subject }

    it { expect(dummy_model.errors).not_to be_empty }
  end

  context 'with empty values' do
    let(:value) { [] }

    it_behaves_like 'returns errors'
  end

  context 'with valid values' do
    let(:value) { [1, 2] }

    before { subject }

    it { expect(dummy_model.errors).to be_empty }
  end

  context 'with invalid values' do
    let(:value) { (11..20) }

    it_behaves_like 'returns errors'
  end
end
