# == Schema Information
#
# Table name: reviews
#
#  id             :bigint           not null, primary key
#  rating         :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  interviewee_id :bigint
#  interviewer_id :bigint
#  project_id     :bigint
#
# Indexes
#
#  index_reviews_on_interviewee_id  (interviewee_id)
#  index_reviews_on_interviewer_id  (interviewer_id)
#  index_reviews_on_project_id      (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#

class Review < ApplicationRecord
    belongs_to: project
    has_many: users

    validates :rating, numericality: true, greater_than: 0
end
