require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other_user) { create :user }
    let(:question) { create(:question, user_id: user.id) }
    let(:other_question) { create(:question, user_id: other_user.id) }
    let(:answer) { create(:answer, question: question, user_id: user.id) }
    let(:other_answer) { create(:answer, question: question, user_id: other_user.id) }
    let(:link) { create(:link, linkable: question) }

    context 'only read all' do
      it { should_not be_able_to :manage, :all }
      it { should be_able_to :read, :all}
    end

    context 'can create' do
      it { should be_able_to :create, Question }
      it { should be_able_to :create, Answer }
      it { should be_able_to :create, Comment }
    end

    context 'can update, destroy' do
      it { should be_able_to [:update, :destroy], question }
      it { should_not be_able_to [:update, :destroy], other_question }

      it { should be_able_to [:update, :destroy], answer }
      it { should_not be_able_to [:update, :destroy], other_answer }
    end

    context 'select best answer' do
      it { should be_able_to :select_best, create(:answer, question: question, user_id: other_user.id) }
      it { should_not be_able_to :select_best, create(:answer, question: other_question, user_id: user.id) }
    end

    context 'link' do
      it { should be_able_to :destroy, create(:link, linkable: question) }
      it { should_not be_able_to :destroy, create(:link, linkable: other_question) }
    end

    context 'can voted' do
      it { should be_able_to [:like, :dislike, :cancel], other_question }
      it { should_not be_able_to [:like, :dislike, :cancel], question }

      it { should be_able_to [:like, :dislike, :cancel], other_answer }
      it { should_not be_able_to [:like, :dislike, :cancel], answer }
    end
  end
end
