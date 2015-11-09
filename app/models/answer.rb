class Answer < ActiveRecord::Base

  validates :body, :question_id, presence: true

  belongs_to :question
end
