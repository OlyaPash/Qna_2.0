module Voted
  extend ActiveSupport::Concern

  included do
    LIKE = 1.freeze
    DISLIKE = -1.freeze

    before_action :find_votable, only: %i[like dislike cancel]
  end

  def like
    voted(LIKE)
  end

  def dislike
    voted(DISLIKE)
  end

  def cancel
    @votable.votes.where(user_id: current_user.id).first.destroy

    render_json
  end

  private

  def find_votable
    @votable = model_klass.find(params[:id])
  end

  def model_klass
    controller_name.classify.constantize
  end

  def voted(value)
    current_user.vote(@votable, value)
    render_json
  end

  def render_json
    render json: { rating: @votable.rating,
                   votable_name: @votable.class.name.downcase,
                   votable_id: @votable.id }
  end
end
