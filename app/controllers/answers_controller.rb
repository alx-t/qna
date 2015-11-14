class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question
  before_action :load_answer, only: [:edit, :update, :destroy]

  def new
    @answer = @question.answers.new
  end

  def edit
    unless @answer.user == current_user
      flash[:danger] = "You can not edit this answer"
      redirect_to question_path @question
    end
  end

  def create
    @answer = current_user.answers.build(answer_params)

    if @answer.save
      flash[:success] = "Your answer successfully created"
      redirect_to @question
    else
      p @answer.errors
      render :new
    end
  end

  def update
    if @answer.update(answer_params)
      flash[:success] = "Your answer successfully changed"
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    if @answer.user == current_user
      @answer.destroy
      flash[:success] = "Your answer successfully deleted"
      redirect_to @question
    else
      flash[:danger] = "You can not delete this answer"
      redirect_to question_path @question
    end
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = @question.answers.find_by(id: params[:id])
  end

  def answer_params
    params.require(:answer).permit(:question_id, :body).merge(question: @question)
  end
end
