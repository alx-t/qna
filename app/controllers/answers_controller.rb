class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question
  before_action :load_answer, only: [:edit, :update, :destroy, :set_best]
  after_action :publish_answer, only: :create

  include Voted

  respond_to :js, :json

  def edit
    unless @answer.user == current_user
      flash[:danger] = "You can not edit this answer"
      respond_with @question
    end
  end

  def create
    respond_with(@answer = current_user.answers.create(answer_params.merge(question: @question)))
  end

  def update
    @answer.update(answer_params)
    respond_with @answer
  end

  def destroy
    respond_with(@answer.destroy) if @answer.user == current_user
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

  def publish_answer
      PrivatePub.publish_to "/questions/#{@question.id}/answers", answer: render_to_string('answers/show.json.jbuilder') if @answer.errors.empty?
  end

  def answer_params
    params.require(:answer)
      .permit(:body, attachments_attributes: [:file, :id, :_destroy])
  end
end

