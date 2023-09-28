class QuestionsController < ApplicationController
  include Voted
  include Commented
  
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy]
  before_action :find_subscription, only: %i[show update]

  after_action :publish_question, only: [:create]

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
    @answer.links.new
    gon.question_id = @question.id
    gon.user_id = current_user.id if current_user
  end

  def new
    @question = Question.new
    @question.links.new
    @question.build_badge
  end

  def edit; end

  def create
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    @question.user = current_user

    @question.update(question_params)
  end

  def destroy
    @question.destroy
    redirect_to questions_path, notice: 'Your question successfully delete.'
  end

  private

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      ApplicationController.render(
        partial: 'questions/question_partial',
        locals: { question: @question }
      )
    )
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                     links_attributes: [:name, :url, :_destroy, :id],
                                     badge_attributes: [:name, :image])
  end

  def find_subscription
    @subscription = @question.subscriptions.find_by(user: current_user)
  end
end
