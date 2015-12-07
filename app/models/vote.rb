class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, presence: true
  validates :user_id, presence: true, uniqueness: { case_sensitive: true, scope: [:votable_type, :votable_id] }

  scope :upvotes, -> { where(value: 1) }
  scope :downvotes, -> { where(value: -1) }

  def update_vote(value)
    case value
      when :up
        self.value = 1
        save
      when :down
        self.value = -1
        save
      when :reset
        self.destroy
    end
  end

  def self.rating
    sum(:value)
  end
end

