class Subscription < ActiveRecord::Base
  belongs_to :subscriber, class_name: 'User', foreign_key: 'user_id'
  belongs_to :subscription, class_name: 'Question', foreign_key: 'question_id'

  validates :subscriber, :subscription, presence: true
end
