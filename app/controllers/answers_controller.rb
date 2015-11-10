class AnswersController < ApplicationController
  before_action :load_question
  before_action :load_answer, only: [:edit, :update, :destroy]

  def new
    @answer = @question.answers.new
  end

  def edit
  end

  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      redirect_to @question
    else
      render :new
    end
  end

  def update
    if @answer.update(answer_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    @answer.destroy
    redirect_to @question
  end

  private

  def load_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = @question.answers.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:question_id, :body)
  end
end

