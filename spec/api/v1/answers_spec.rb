require 'rails_helper'

describe 'Answers API' do
  let!(:question) { create :question }

  describe 'GET /index' do

    it_behaves_like "API Authenticable" do
      let(:http_method) { 'get' }
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    end

    context 'authorized' do
      let(:access_token) { create :access_token }
      let!(:answers) { create_list :answer, 2, question: question }
      let(:answer) { answers.first }

      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2).at_path("answers")
      end

      %w(id body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do
    let(:answer) { create :answer, question: question }

    it_behaves_like "API Authenticable" do
      let(:http_method) { 'get' }
      let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }
    end

    context 'authorized' do
      let(:user) { create :user }
      let(:access_token) { create :access_token, resource_owner_id: user }
      let!(:comment) { create :answer_comment, commentable: answer }
      let!(:attachment) { create :answer_attachment, attachable: answer }

      before { get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json, access_token: access_token.token }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(id body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context 'answer contains comments' do
        %w(id body user_id commentable_id commentable_type created_at updated_at).each do |attr|
          it "answer's comment contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context 'answer contains attachments' do
        it "answer's attachment contains file url" do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("answer/attachments/0/url")
        end
      end
    end
  end

  describe 'POST /create' do

    it_behaves_like "API Authenticable" do
      let(:http_method) { 'post' }
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    end

    context 'authorized' do
      let(:user) { create :user }
      let(:access_token) { create :access_token, resource_owner_id: user.id }

      context 'with valid attributes' do
        it 'returns created status' do
          post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token, answer: attributes_for(:answer)
          expect(response).to be_success
        end

        it 'creates new answer' do
          expect {
            post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token, answer: attributes_for(:answer)
          }.to change(question.answers, :count).by(1)
        end
      end

      context 'with invalid attributes' do
        it 'returns unprocessable_entity status' do
          post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token, answer: attributes_for(:invalid_answer)
          expect(response.status).to eql 422
        end

        it 'tries to create answer' do
          expect {
            post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token, answer: attributes_for(:invalid_answer)
          }.to_not change(question.answers, :count)
        end
      end
    end
  end
end

