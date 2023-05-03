require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_many(:links).dependent(:destroy) }
  
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  context 'Best answer' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user_id: user.id) }
    let!(:answer) { create(:answer, question_id: question.id, user_id: user.id) }
    let!(:answer2) { create(:answer, :best, question_id: question.id, user_id: user.id) }

    it 'question have best answers' do
      answer.mark_as_best

      expect(answer).to be_best
    end

    it 'previous answer is not the best' do
      answer.mark_as_best
      answer2.reload

      expect(answer2).not_to be_best
    end
  end

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it_behaves_like 'votable'
  it_behaves_like 'commentable'
end
