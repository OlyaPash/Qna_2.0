class Answer < ApplicationRecord
  include Votable
  include Commentable
  
  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable
  
  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  scope :sort_by_best, -> { order(best: :desc) }

  validates :body, presence: true

  def mark_as_best
    transaction do
			Answer.where(question_id: question_id).update_all(best: false)
			update!(best: true)
      question.badge&.update!(user: user)
		end
	end
end
