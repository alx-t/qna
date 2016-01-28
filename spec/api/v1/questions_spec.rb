require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do

    it_behaves_like "API Authenticable" do
      let(:api_path) { '/api/v1/questions' }
    end

    context 'authorized' do
      let(:access_token) { create :access_token }
      let!(:questions) { create_list :question, 2 }
      let(:question) { questions.first }
      let!(:answer) { create :answer, question: question }

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path("questions")
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          question = questions.first
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("questions/0/short_title")
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('questions/0/answers')
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET /show' do
    let(:question) { create :question }

    it_behaves_like "API Authenticable" do
      let(:api_path) { "/api/v1/questions/#{question.id}" }
    end

    context 'authorized' do
      let(:user) { create :user }
      let(:access_token) { create :access_token, resource_owner_id: user.id }
      let!(:answer) { create :answer, question: question }
      let!(:comment) { create :question_comment, commentable: question }
      let!(:attachment) { create :question_attachment, attachable: question }

      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      context 'question contains answers' do
        %w(id body question_id created_at updated_at).each do |attr|
          it "question's answer contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("question/answers/0/#{attr}")
          end
        end
      end

      context 'question contains comments' do
        %w(id body user_id commentable_id commentable_type created_at updated_at).each do |attr|
          it "question's comment contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
          end
        end
      end

      context 'question contains attachments' do
        it "question's attachment contains file url" do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("question/attachments/0/url")
        end
      end
    end
  end

  describe 'POST /create' do

    it_behaves_like "API Authenticable" do
      let(:http_method) { 'post' }
      let(:api_path) { "/api/v1/questions/" }
    end

    context 'authorized' do
      let(:user) { create :user }
      let(:access_token) { create :access_token, resource_owner_id: user.id }

      context 'with valid attributes' do
        it 'returns created status' do
          post '/api/v1/questions', format: :json, access_token: access_token.token, question: attributes_for(:question)
          expect(response).to be_success
        end

        it 'created new question' do
          expect {
            post '/api/v1/questions', format: :json, access_token: access_token.token, question: attributes_for(:question)
          }.to change(user.questions, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'returns unprocessable_entity status' do
          post '/api/v1/questions', format: :json, access_token: access_token.token, question: attributes_for(:invalid_question)
          expect(response.status).to eql 422
        end

        it 'tries to create question' do
          expect {
            post '/api/v1/questions', format: :json, access_token: access_token.token, question: attributes_for(:invalid_question)
          }.to_not change(user.questions, :count)
        end
      end
    end
  end
end

