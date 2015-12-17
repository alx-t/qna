class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_question, only: [:edit, :update, :destroy]
  before_action :build_answer, only: :show
  after_action :publish_question, only: :create

  include Voted

  respond_to :js, :json

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with(@question = current_user.questions.new)
  end

  def edit
    if @question.nil?
      flash[:danger] = "You can not edit this question"
      redirect_to questions_path
    end
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with(current_user.questions.destroy(@question), location: questions_path) unless @question.nil?
  end

  private

  def load_question
    @question = current_user.questions.find_by(id: params[:id])
  end

  def build_answer
    @question = Question.find(params[:id])
    @answer = @question.answers.build
  end

  def publish_question
    PrivatePub.publish_to "/questions", question: QuestionPresenter.new(@question).to_json if @question.errors.empty?
  end

  def question_params
    params.require(:question)
          .permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end
end

