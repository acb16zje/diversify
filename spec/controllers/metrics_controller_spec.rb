# frozen_string_literal: true

require 'rails_helper'

describe MetricsController do
  describe '#update_graph_time' do
    context 'with invalid params' do
      it 'receive 400 Bad Request' do
        expect { post :update_graph_time, xhr: true }
          .to raise_error ActionController::ParameterMissing
      end
    end
  end
end
