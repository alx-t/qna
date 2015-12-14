class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question
  before_action :load_answer, only: [:edit, :update, :destroy, :set_best]

  include Voted

  #respond_to :js, :json

  def edit
    unless @answer.user == current_user
      flash[:danger] = "You can not edit this answer"
      redirect_to question_path @question
    end
  end

  def create
    @answer = current_user.answers.build(answer_params.merge(question: @question))
    if @answer.save
      PrivatePub.publish_to "/questions/#{@question.id}/answers", answer: render_to_string('answers/show')
      render nothing: true
    else
      render json: @answer.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if @answer.update(answer_params)
      flash.now[:success] = "Your answer successfully changed"
    else
      flash.now[:danger] = "Errors: #{@answer.errors.full_messages}"
    end
  end

  def destroy
    if @answer.user == current_user
      @answer.destroy
      flash.now[:success] = "Your answer successfully deleted"
    else
      flash.now[:danger] = "You can not delete this answer"
    end
  end

  def set_best
    @answer.set_best if @question.user == current_user
    flash.now[:success] = "Your best answer successfully selected"
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = @question.answers.find_by(id: params[:id])
  end

  def answer_params
    params.require(:answer)
      .permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end
end

