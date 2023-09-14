require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:user) { create(:user) }
    let(:question) { create(:question, user_id: user.id) }
    let!(:answers) { create_list(:answer, 3, question: question, user: user) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answers'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 3
      end

      it_behaves_like 'Returns public fields' do
        let(:attrs) { %w[id body created_at updated_at] }
        let(:resource_response) { json['answers'].first }
        let(:resource) { answers.first }
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let!(:comments) { create_list(:comment, 2, commentable: answer, user: user) }
    let!(:links) { create_list(:link, 2, linkable: answer) }

    before { answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb') }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it_behaves_like 'Returns public fields' do
        let(:attrs) { %w[id body created_at updated_at] }
        let(:resource_response) { json['answer'] }
        let(:resource) { answer }
      end

      it 'contains comments list' do
        expect(json['answer']['comments'].size).to eq 2
      end

      it 'contains links list' do
        expect(json['answer']['links'].size).to eq 2
      end

      it 'contains attachments url list' do
        %w[files].each do |attr|
          expect(json['answer'][attr].size).to eq answer.send(attr).size
        end
      end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      before do 
        post api_path, params: { access_token: access_token.token, answer: attributes_for(:answer) }, headers: headers
      end

      it 'return new answer' do
        expect(Answer.count).to eq 1
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      before do
        patch api_path, params: { access_token: access_token.token, 
                                  id: answer, 
                                  answer: { body: 'body' } }
      end

      it 'changes question' do
        answer.reload

        expect(answer.body).to eq 'body'
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    before do
      delete api_path, params: { access_token: access_token.token, id: answer }, headers: headers
    end

    it 'successfully deleted' do
      expect(Answer.count).to eq 0
    end
  end
end
