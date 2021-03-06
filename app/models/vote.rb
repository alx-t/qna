class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true, touch: true

  validates :value, presence: true
  validates :user_id, presence: true, uniqueness: { case_sensitive: true, scope: [:votable_type, :votable_id] }

  scope :upvotes, -> { where(value: 1) }
  scope :downvotes, -> { where(value: -1) }

  def update_vote(value)
    self.value = value
    save
  end

  def reset_vote
    self.destroy
  end

  def self.rating
    sum(:value)
  end
end

