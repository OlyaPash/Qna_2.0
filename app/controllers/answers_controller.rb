class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[index new show create]
  before_action :find_answer, only: %i[show destroy update select_best]
  before_action :returns_associated, only: %i[update select_best destroy]

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
    end
  end

  def select_best
    @answer.mark_as_best if current_user.author?(@answer)
  end

  def destroy
    if current_user.author?(@answer)
      @answer.destroy
    end
  end

  private
  
  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url, :_destroy])
  end

  def returns_associated
    @question = @answer.question
  end
end
