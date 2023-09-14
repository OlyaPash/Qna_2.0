class Api::V1::AnswersController < Api::V1::BaseController
  before_action :find_question, only: %i[index create]
  before_action :find_answer, only: %i[show destroy update]

  authorize_resource

  def index
    @answers = @question.answers
    render json: @answers
  end

  def show
    render json: @answer
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_resource_owner

    if @answer.save
      render json: @answer
    else
      render json: { errors: @answer.errors}, status: :unprocessable_entity
    end
  end

  def update
    if can?(:update, @answer)
      if @answer.update(answer_params)
        render json: @answer
      else
        render json: { errors: @answer.errors}, status: :unprocessable_entity
      end
    end
  end

  def destroy
    @answer.destroy if can?(:destroy, @answer)
  end

  private
  
  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
