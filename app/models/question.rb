class Question < ApplicationRecord
  include Votable
  include Commentable
  
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :subscriptions, dependent: :destroy
  has_one :badge, dependent: :destroy
  belongs_to :user
  
  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :badge, reject_if: :all_blank
  
  validates :title, :body, presence: true

  after_create :calculate_reputation
  after_create :author_subscribed
  after_create :send_digest

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end

  def author_subscribed
    subscriptions.create(user: user)
  end

  def send_digest
    DailyDigestJob.perform_later(self)
  end
end
