# frozen_string_literal: true

# rubocop:disable RSpec/PredicateMatcher
# rubocop:disable RSpec/MultipleExpectations

require 'rails_helper'

describe ApplicationHelper, type: :helper do
  describe '#current_path?' do
    subject { current_path?(root_path) }

    before { allow(helper).to receive(:request).and_return(request) }

    context 'when request.path == path' do
      let(:request) { instance_double('request', path: root_path) }

      it { is_expected.to be_truthy }
    end

    context 'when request.path != path' do
      let(:request) { instance_double('request', path: '/foobar') }

      it { is_expected.to be_falsey }
    end
  end

  describe '#current_controller?' do
    def stub_controller_name(value)
      allow(helper.controller).to receive(:controller_name).and_return(value)
    end

    def stub_controller_path(value)
      allow(helper.controller).to receive(:controller_path).and_return(value)
    end

    before { stub_controller_name('foo') }

    it 'returns true when controller matches argument' do
      expect(helper.current_controller?(:foo)).to be_truthy
    end

    it 'returns false when controller does not match argument' do
      expect(helper.current_controller?(:bar)).to be_falsey
    end

    it 'takes any number of arguments' do
      expect(helper.current_controller?(:baz, :bar)).to be_falsey
      expect(helper.current_controller?(:baz, :bar, :foo)).to be_truthy
    end

    context 'when namespaced' do
      before { stub_controller_path('bar/foo') }

      it 'returns true when controller matches argument' do
        expect(helper.current_controller?(:foo)).to be_truthy
      end

      it 'returns true when controller and namespace matches argument in path notation' do
        expect(helper.current_controller?('bar/foo')).to be_truthy
      end

      it 'returns false when namespace doesnt match' do
        expect(helper.current_controller?('foo/foo')).to be_falsey
      end
    end
  end

  describe 'current_action?' do
    def stub_action_name(value)
      allow(helper).to receive(:action_name).and_return(value)
    end

    before { stub_action_name('foo') }

    it 'returns true when action matches' do
      expect(helper.current_action?(:foo)).to be_truthy
    end

    it 'returns false when action does not match' do
      expect(helper.current_action?(:bar)).to be_falsey
    end

    it 'takes any number of arguments' do
      expect(helper.current_action?(:baz, :bar)).to be_falsey
      expect(helper.current_action?(:baz, :bar, :foo)).to be_truthy
    end
  end
end

# rubocop:enable RSpec/PredicateMatcher
# rubocop:enable RSpec/MultipleExpectations
