class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :load_question, only: [:edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @question = Question.find(params[:id])
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def new
    @question = current_user.questions.new
    @question.attachments.build
  end

  def edit
    if @question.nil?
      flash[:danger] = "You can not edit this question"
      redirect_to questions_path
    end
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      flash[:success] = "Your question successfully created."
      redirect_to @question
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      flash[:success] = "Your question successfully changed"
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    if @question.nil?
      flash[:danger] = "You can not delete this question"
      redirect_to questions_path
    else
      current_user.questions.destroy(@question)
      flash[:success] = "Your question successfully deleted"
      redirect_to questions_path
    end
  end

  private

  def load_question
    @question = current_user.questions.find_by(id: params[:id])
  end

  def question_params
    params.require(:question)
          .permit(:title, :body, attachments_attributes: [:file, :id, :_destroy])
  end
end

