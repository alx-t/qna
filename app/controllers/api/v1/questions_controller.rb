class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    respond_with Question.all
  end

  def show
    respond_with Question.find(params[:id]), serializer: QuestionSerializer::Question
  end

  def create
    respond_with current_resource_owner.questions.create(question_params)
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end
end

