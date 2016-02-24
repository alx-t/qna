class Question < ActiveRecord::Base

  include Attachable
  include Votable
  include Commentable

  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, class_name: 'User'

  scope :yesterdays, -> { where(created_at: Date.yesterday.to_time.all_day) }

  validates :title, :body, :user_id, presence: true

  after_create :subscribe_author
  after_save :store_hashtags

  def subscribe(user)
    subscribers << user unless subscribed? user
  end

  def unsubscribe(user)
    subscribers.delete(user) if subscribed? user
  end

  def subscribed?(user)
    subscribers.include? user
  end

  private

  def subscribe_author
    subscribe user
  end

  def store_hashtags
    hashtags_array = self.body.scan(/#\w*/).map(&:downcase).sort
    unless self.hashtags == hashtags_array
      self.update_attributes(hashtags: hashtags_array)
    end
  end
end

