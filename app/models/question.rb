class Question < ActiveRecord::Base

  include Attachable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  belongs_to :user

  scope :yesterdays, -> { where(created_at: Date.yesterday.to_time.all_day) }

  validates :title, :body, :user_id, presence: true
end
