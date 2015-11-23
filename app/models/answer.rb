class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable, dependent: :destroy

  validates :body, :question_id, :user_id, presence: true

  accepts_nested_attributes_for :attachments,
                                reject_if: :all_blank,
                                allow_destroy: true

  default_scope -> { order(is_best: :desc).order(created_at: :asc) }

  def set_best
    ActiveRecord::Base.transaction do
      question.answers.update_all is_best: false
      update!(is_best: true)
    end
  end
end

