# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id         :bigint           not null, primary key
#  name       :string           default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Category < ApplicationRecord
  has_many :skills
  has_many :projects

  validates :name, uniqueness: true
end
