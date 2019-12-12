# == Schema Information
#
# Table name: newsletters
#
#  id         :bigint           not null, primary key
#  content    :text             not null
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Newsletter < ApplicationRecord
  validates :content, :title, presence: true
end
