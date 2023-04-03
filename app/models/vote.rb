class Vote < ApplicationRecord
  belongs_to :user

  belongs_to :votable, polymorphic: true
  
  validates :user, presence: true, uniqueness: { scope: :votable_id }
end
