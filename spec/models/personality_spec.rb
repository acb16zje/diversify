# == Schema Information
#
# Table name: personalities
#
#  id         :bigint           not null, primary key
#  trait      :string           default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Personality, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
