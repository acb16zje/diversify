# frozen_string_literal: true

require 'rails_helper'

# rubocop:disable Layout/LineLength
describe NavHelper, type: :helper do
  include ApplicationHelper

  describe '#nav_link_to' do
    let(:request) { instance_double('request', path: root_path) }

    before do
      allow(controller).to receive(:controller_name).and_return('foo')
      allow(self).to receive(:action_name).and_return('bar')
      allow(helper).to receive(:request).and_return(request)
    end

    context 'with path params only' do
      it { expect(nav_link_to('', path: root_path)).to match(/active/) }
      it { expect(nav_link_to('', path: metrics_path)).not_to match(/active/) }
    end

    context 'with controller params only' do
      it { expect(nav_link_to('', path: '', controller: :foo)).to match(/active/) }
      it { expect(nav_link_to('', path: '', controller: :bar)).not_to match(/active/) }
    end

    context 'with action params only' do
      it { expect(nav_link_to('', path: '', action: :foo)).not_to match(/active/) }
      it { expect(nav_link_to('', path: '', action: :bar)).to match(/active/) }
    end

    context 'with controller, and action param' do
      it { expect(nav_link_to('', path: '', controller: :foo, action: :bar)).to match(/active/) }
      it { expect(nav_link_to('', path: '', controller: :foo, action: :foo)).not_to match(/active/) }
      it { expect(nav_link_to('', path: '', controller: :bar, action: :foo)).not_to match(/active/) }
      it { expect(nav_link_to('', path: '', controller: :bar, action: :bar)).not_to match(/active/) }
    end

    context 'with block given' do
      subject { nav_link_to('', path: '') { string } }

      let(:string) { '<span class="iconify"></span>' }

      it 'returns with the block enclosed' do
        is_expected.to include(ERB::Util.html_escape(string))
      end
    end
  end
end
# rubocop:enable Layout/LineLength
