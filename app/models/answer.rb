class Answer < ActiveRecord::Base

  include Attachable
  include Votable
  include Commentable

  belongs_to :question, touch: true
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true

  default_scope -> { order(is_best: :desc).order(created_at: :asc) }

  #after_create :notify_subscribers
  after_commit :notify_subscribers

  def set_best
    ActiveRecord::Base.transaction do
      question.answers.update_all is_best: false
      update!(is_best: true)
    end
  end

  private

  def notify_subscribers
    NotifySubscribersJob.perform_later(question)
  end
end

