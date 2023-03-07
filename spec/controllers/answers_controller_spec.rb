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
        expect do
          post :create, params: {  answer: attributes_for(:answer).merge(user_id: user.id), question_id: question }, 
                        format: :js 
        end.to change(Answer, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    let!(:answer) { create(:answer, question: question, user: user) }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer'do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'user author answer' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
        answer.reload
        
        expect(assigns(:answer)).to eq answer
      end

      it 'renders update view' do
        patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js }
        expect(response).to render_template :update
      end
    end

    context 'user not author answer' do
      let(:other_user) { create(:user) }
      let(:other_answer) { create(:answer, question: question, user_id: other_user.id) }

      it 'does not change question' do
        patch :update, params: { id: other_answer, answer: { body: 'new body' }, format: :js }
        answer.reload

        expect(assigns(:other_answer)).to_not eq 'new body'
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
