class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true, touch: true

  validates :body, presence: true
  validates :user_id, presence: true#,
                      #uniqueness: {
                      #  case_sensitive: true,
                      #  scope: [:commentable_type, :commentable_id]
                      #}

  default_scope -> { order(created_at: :asc) }
end
