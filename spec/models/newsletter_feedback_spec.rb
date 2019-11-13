# == Schema Information
#
# Table name: newsletter_feedbacks
#
#  id         :bigint           not null, primary key
#  email      :string           default(""), not null
#  reason     :string           default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe NewsletterFeedback, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
