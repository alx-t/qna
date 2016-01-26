class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource Answer

  before_action :load_question, only: [:index, :create]

  def index
    respond_with @question.answers
  end

  def show
   respond_with Answer.find(params[:id]), serializer: AnswerSerializer::Answer
  end

  def create
    respond_with @question.answers.create(answer_params.merge(user: current_resource_owner)), location: question_path(@question)
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end

