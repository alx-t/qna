module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up(user)
    set_vote(user, 1)
  end

  def vote_down(user)
    set_vote(user, -1)
  end

  def vote_reset(user)
    delete_vote(user)
  end

  def voted_for?(user)
    votes.any? && votes.rating != 0
  end

  private

  def set_vote(user, value)
    vote = votes.find_or_create_by(user: user)
    vote.update_vote(value)
  end

  def delete_vote(user)
    vote = votes.find_by(user: user)
    vote.reset_vote unless vote.nil?
  end
end

