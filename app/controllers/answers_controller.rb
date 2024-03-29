class AnswersController < ApplicationController
  include Voted
  include Commented
  
  before_action :authenticate_user!, except: %i[index show]
  before_action :find_question, only: %i[index new show create]
  before_action :find_answer, only: %i[show destroy update select_best]
  before_action :returns_associated, only: %i[update select_best destroy]

  after_action :publish_answer, only: [:create]

  authorize_resource

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
    @answer.update(answer_params)
  end

  def select_best
    @answer.mark_as_best
  end

  def destroy
    @answer.destroy
  end

  private

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "questions/#{params[:question_id]}/answers",
      ApplicationController.render(
        partial: 'answers/for_channel',
        locals: { answer: @answer }
      )
    )
  end
  
  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], 
                                   links_attributes: [:name, :url, :_destroy, :id],
                                   badge_attributes: [:name, :image])
  end

  def returns_associated
    @question = @answer.question
  end
end
