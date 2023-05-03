module Commented
  extend ActiveSupport::Concern

included do
  after_action :publish_comment, only: [:comment]
end

  def comment
    find_commentable
    
    @comment = @commentable.comments.create!(comment_params.merge(user: current_user))
  end

  private

  def publish_comment
    return if @comment.errors.any?

    question_id = @commentable.is_a?(Question) ? @commentable.id : @commentable.question.id
    ActionCable.server.broadcast(
      "comment-#{question_id}", {
      partial: ApplicationController.render(
        partial: 'comments/comment',
        locals: { comment: @comment }
      ),
      commentable_type: @comment.commentable_type,
      commentable_id: @commentable.id
      }
    )
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def find_commentable
    @commentable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end
end
