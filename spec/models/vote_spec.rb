require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :user }
  it { should belong_to :votable }
  it { should validate_presence_of :user }

  describe 'uniqueness' do
    subject { build(:vote, :like) }
    it { should validate_uniqueness_of(:user).scoped_to(:votable_id) }
  end
end
