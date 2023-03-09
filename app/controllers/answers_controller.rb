class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[index new show create]
  before_action :load_answer, only: %i[show destroy update select_best]

  def index
    @answers = @question.answers
  end

  def new
    @answer = @question.answers.new
  end

  def show; end

  def create
    @answer = @question.answers.create(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    if current_user.author?(@answer)
      @answer.update(answer_params)
      @question = @answer.question
    end
  end

  def select_best
    @question = @answer.question
    @answer.mark_as_best if current_user.author?(@answer)
  end

  def destroy
    if current_user.author?(@answer)
      @answer.destroy
    end
    @question = @answer.question
  end

  private
  
  def find_question
    @question = Question.find(params[:question_id])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
