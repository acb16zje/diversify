# frozen_string_literal: true

require 'rails_helper'

describe 'Landing page > Newsletter', :js, type: :system do
  before { visit newsletter_pages_path }

  describe 'Share on Facebook' do
    it 'clicks Share button' do
      within_frame('fb') do
        find('#facebook a').click
      end
    end
  end

  describe 'Tweet on Twitter' do
    it 'clicks Tweet button' do
      within_frame('twitter-widget-0') do
        find('#widget a').click
      end
    end
  end
end
