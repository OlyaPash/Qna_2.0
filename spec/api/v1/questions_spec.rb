require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "ACCEPT" => 'application/json' } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      # it 'returns all public fields' do
      #   %w[id title body created_at updated_at].each do |attr|
      #     expect(question_response[attr]).to eq question.send(attr).as_json
      #   end
      # end

      it_behaves_like 'Returns public fields' do
        let(:attrs) { %w[id title body created_at updated_at] }
        let(:resource_response) { json['questions'].first }
        let(:resource) { questions.first }
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:question) { create(:question, user_id: user.id) }
    let!(:comments) { create_list(:comment, 2, commentable: question, user: user) }
    let!(:links) { create_list(:link, 2, linkable: question) }
    let(:question_response) { json['question'].first }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    before { question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb') }

    before { get api_path, params: { access_token: access_token.token }, headers: headers }

    it 'returns 200 status' do
      expect(response).to be_successful
    end

    it 'contains comments list' do
      expect(json['question']['comments'].size).to eq 2
    end

    it 'contains links list' do
      expect(json['question']['links'].size).to eq 2
    end

    it 'contains attachments url list' do
      # attachments_url = Rails.application.routes.url_helpers
      %w[files].each do |attr|
        expect(json['question'][attr].size).to eq question.send(attr).size
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user_id: user.id) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      before do 
        post api_path, params: { access_token: access_token.token, question: attributes_for(:question) }, headers: headers
      end

      it 'return new question' do
        expect(Question.count).to eq 1
      end

      it 'status created' do
        expect(response.status).to eq 200
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user_id: user.id) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      before do
        patch api_path, params: { access_token: access_token.token, 
                                  id: question, 
                                  question: { title: 'title', body: 'body' } }
      end

      it 'changes question' do
        question.reload

        expect(question.title).to eq 'title'
        expect(question.body).to eq 'body'
      end

      it 'returns status Ok' do
        expect(response.status).to eq 200
      end
    end
  end

  describe 'DELETE /api/v1/questions' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user_id: user.id) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    before do
      delete api_path, params: { access_token: access_token.token, id: question }, headers: headers
    end

    it 'successfully deleted' do
      expect(Question.count).to eq 0
    end
  end
end
