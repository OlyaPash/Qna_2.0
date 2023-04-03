require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :questions }
  it { should have_many :answers }
  it { should have_many :badges }
  it { should have_many :votes }
  
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe 'Author?' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:question1) { create(:question, user_id: user1.id) }

    context 'question' do
      let(:question2) { create(:question, user_id: user2.id) }

      it 'user is author' do
        expect(user1).to be_author(question1)
      end

      it 'user is not author' do
        expect(user1).to_not be_author(question2)
      end
    end

    context 'answer' do
      let(:answer) { create(:answer, question_id: question1.id, user_id: user1.id) }

      it 'user is author' do
        expect(user1).to be_author(answer)
      end

      it 'user is not author' do
        expect(user2).to_not be_author(answer)
      end
    end
  end
end
