class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  
  has_many_attached :files

  scope :sort_by_best, -> { order(best: :desc) }

  validates :body, presence: true

  def mark_as_best
		transaction do
			self.class.where(question_id: self.question_id).update_all(best: false)
			update!(best: true)
		end
	end
end
