module Voted
  extend ActiveSupport::Concern

  def vote_up
    set_vote(:up)
  end

  def vote_down
    set_vote(:down)
  end

  def vote_reset
    set_vote(:reset)
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_vote(value)
    @votable = model_klass.find(params[:id])

    unless current_user.id == @votable.user_id
      @votable.send("vote_#{value}", current_user)
    end
    render :vote
  end
end

