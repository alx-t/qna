class Answer < ActiveRecord::Base

  include Attachable
  include Votable

  belongs_to :question
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true

  default_scope -> { order(is_best: :desc).order(created_at: :asc) }

  def set_best
    ActiveRecord::Base.transaction do
      question.answers.update_all is_best: false
      update!(is_best: true)
    end
  end
end

