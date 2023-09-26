require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user_id: user.id) }
  
  before { login(user) }
  describe 'POST #create' do
    it 'saves a new subscribe' do
      expect { post :create, params: { question_id: question.id, format: :js } }.to change(question.subscriptions, :count).by(1)
    end
  end

  describe 'POST #destroy' do
    let!(:subscription) { create(:subscription, question_id: question.id, user_id: user.id) }

    it 'destroy subscribe' do
      expect { delete :destroy, params: { id: question.id, format: :js } }.to change(Subscription, :count).by(-1)
    end
  end
end
