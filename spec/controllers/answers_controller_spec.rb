require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user_id: user.id) }
  let(:answer) { create(:answer, question_id: question.id, user_id: user.id) }

  describe 'GET #index' do
    let(:answers) { create_list(:answer, 3, question: question, user: user) }

    before { get :index, params: { question_id: question } }

    it 'populates an array of all answers' do
      expect(assigns(:answers)).to match_array(answers)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new, params: { question_id: question } }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { login(user) }
    context 'with valid attributes' do
      it 'save a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer).merge(user_id: user.id) } }.to change(Answer, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'User is author' do
      before { login(user) }
      let!(:answer) { create(:answer, question: question, user_id: user.id) }

      it 'answer was deleted' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
      end

      it 'redirects to questions list' do
        delete :destroy, params: { id: answer}
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'User is not author' do
      let(:other_user) { create(:user) }
      let!(:other_answer) { create(:answer, question_id: question.id, user_id: other_user.id) }
      before { login(user) }

      it 'tries to delete answer' do
        expect { delete :destroy, params: { id: other_answer } }.to_not change(Answer, :count)
      end

      it 'redirects to questions list' do
        delete :destroy, params: { id: answer}
        expect(response).to redirect_to question_path(question)
      end
    end
  end

end
