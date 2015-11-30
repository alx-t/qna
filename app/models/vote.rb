class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, presence: true
  validates :user_id, presence: true, uniqueness: { case_sensitive: true, scope: [:votable_type, :votable_id] }

  scope :upvotes, -> { where(value: 1).count }
  scope :downvotes, -> { where(value: -1).sum(:value) }
  scope :rating, -> { sum(:value) }

  def update_vote(value)
    self.value = case value
                 when :up     then 1
                 when :down   then -1
                 when :reset  then 0
    end
    save
  end
end

