# frozen_string_literal: true

# == Schema Information
#
# Table name: ckeditor_assets
#
#  id                :bigint           not null, primary key
#  data_content_type :string
#  data_file_name    :string           not null
#  data_file_size    :integer
#  data_fingerprint  :string
#  type              :string(30)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_ckeditor_assets_on_type  (type)
#

require 'rails_helper'

describe Ckeditor::Picture do
  def create_picture
    picture = Ckeditor.picture_model.new(data: data)
    picture.save!
    picture
  end

  def create_attachment
    attachment = Ckeditor.attachment_file_model.new(data: data)
    attachment.save!
    attachment
  end

  let(:data) {
    fixture_file_upload(
      File.join(Rails.root, '/app/assets/images/avatar/large/ade.jpg'),
      'image/jpg'
    )
  }

  let(:picture) { create_picture }

  let(:attachment) { create_attachment }

  describe 'create picture' do
    it { picture }
  end

  describe 'upload attachment' do
    it { attachment }
  end

  it { expect(picture.url_thumb).to match(%r{.*/representations/.*/ade.jpg}) }

  it { expect(picture.url_content).to match(%r{.*/representations/.*/ade.jpg}) }

  it {
    expect(attachment.url_thumb).to eq('ckeditor/filebrowser/thumbs/jpg.gif')
  }
end
