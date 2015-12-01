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
    #instance_variable_set("@#{controller_name.singularize}", @votable)
    #instance_variable_get("@#{controller_name.singularize}").send("vote_#{value}", current_user)
    #if current_user.id == @votable.user_id
      #flash.now[:danger] = "You can not vote this question"
      #render :vote
      #return
    #end
    @votable.send("vote_#{value}", current_user)
    if @votable.valid?
      #flash.now[:success] = "Your question successfully created."
      render :vote
    else
      #flash.now[:danger] = "Errors: #{@answer.errors.full_messages}"
      render :vote
    end
  end
end
