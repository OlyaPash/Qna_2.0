require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:question) { create(:question, user_id: user.id) }
  let(:answer) { create(:answer, question_id: question.id, user_id: user.id) }
  let(:user_not_author) { create(:user) }
  let(:user) { create(:user) }

  describe 'DELETE #destroy' do
    context 'Delete file from question ' do
      before { question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb') }

      it 'author' do
        login(user)

        expect { delete :destroy, params: { id: question.files.first.id }, format: :js }.to change(question.files, :count).by(-1)
      end

      it 'renders destroy view' do
        login(user)
        delete :destroy, params: { id: question.files.first.id }, format: :js

        expect(response).to render_template :destroy
      end

      it 'no author' do
        login(user_not_author)

        expect { delete :destroy, params: { id: question.files.first.id }, format: :js }.to change(question.files, :count).by(0)
      end
    end

    context 'Delete file from answer' do
      before { answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb') }

      it 'author' do
        login(user)

        expect { delete :destroy, params: { id: answer.files.first.id }, format: :js }.to change(answer.files, :count).by(-1)
      end

      it 'renders destroy view' do
        login(user)
        delete :destroy, params: { id: answer.files.first.id }, format: :js

        expect(response).to render_template :destroy
      end

      it 'no author' do
        login(user_not_author)

        expect { delete :destroy, params: { id: answer.files.first.id }, format: :js }.to change(answer.files, :count).by(0)
      end
    end
  end
end
