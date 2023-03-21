require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:question) { create(:question, user_id: user.id) }
  let(:answer) { create(:answer, question_id: question.id, user_id: user.id) }
  let(:user_not_author) { create(:user) }
  let(:user) { create(:user) }

  describe 'DELETE #destroy' do
    context 'Delete link from question ' do
      before { question.links.create(name: 'My GitHub', url: 'https://github.com/OlyaPash') }

      it 'author' do
        login(user)

        expect { delete :destroy, params: { id: question.links.first.id }, format: :js }.to change(question.links, :count).by(-1)
      end

      it 'renders destroy view' do
        login(user)
        delete :destroy, params: { id: question.links.first.id }, format: :js

        expect(response).to render_template :destroy
      end

      it 'no author' do
        login(user_not_author)

        expect { delete :destroy, params: { id: question.links.first.id }, format: :js }.to change(question.links, :count).by(0)
      end
    end

    context 'Delete link from answer ' do
      before { answer.links.create(name: 'My GitHub', url: 'https://github.com/OlyaPash') }

      it 'author' do
        login(user)

        expect { delete :destroy, params: { id: answer.links.first.id }, format: :js }.to change(answer.links, :count).by(-1)
      end

      it 'renders destroy view' do
        login(user)
        delete :destroy, params: { id: answer.links.first.id }, format: :js

        expect(response).to render_template :destroy
      end

      it 'no author' do
        login(user_not_author)

        expect { delete :destroy, params: { id: answer.links.first.id }, format: :js }.to change(answer.links, :count).by(0)
      end
    end
  end
end
