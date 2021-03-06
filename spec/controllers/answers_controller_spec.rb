require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create :user }
  let(:question) { create :question }
  let(:answer) { create :answer, question: question }
  let(:user_answer) { create :answer, question: question, user: user }

  describe 'GET #edit' do
    before do
      log_in user
      get :edit, id: user_answer, question_id: question
    end

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq user_answer
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    let(:subject) { post :create, question_id: question, answer: attributes_for(:answer), format: :json }
    sign_in_user

    context 'with valid attributes' do

      it 'saves the new answer in th database' do
        expect {  subject }.to change { question.answers.count }.by(1)
      end

      it_behaves_like "Publishable" do
        let(:channel) { "/questions/#{question.id}/answers" }
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create,
               question_id: question,
               answer: attributes_for(:invalid_answer),
               format: :json
        end.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do
    before do
      log_in user
    end

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, id: user_answer,
                       question_id: question,
                       format: :js,
                       answer: { body: 'new body' }
        user_answer.reload
        expect(user_answer.body).to eq 'new body'
      end
    end

    context 'with invalid attributes' do
      before do
        @old_answer = answer
        patch :update,
              id: answer,
              question_id: question,
              format: :js,
              answer: { body: nil }
      end

      it 'does not change answer attributes' do
        answer.reload
        expect(answer.body).to eq @old_answer.body
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      log_in user
      user_answer
    end

    it 'deletes answer' do
      expect { delete :destroy, id: user_answer, question_id: question, format: :js }
        .to change(Answer, :count).by(-1)
    end

    it 'render template destroy' do
      delete :destroy, id: user_answer, question_id: question, format: :js
      expect(response).to render_template :destroy
    end
  end

  describe 'PATCH #set_best' do
    let(:user_question) { create :question, user: user }
    let(:user_question_answer) { create :answer, question: user_question }

    context 'user is author of question' do
      before do
        log_in user
        patch :set_best, question_id: user_question, id: user_question_answer, format: :js
      end

      it 'set best answer' do
        user_question_answer.reload
        expect(user_question_answer.is_best).to eq true
      end

      it 'render template best' do
        expect(response).to render_template :set_best
      end
    end

    context 'user is not author of question' do
      it 'not set best answer' do
        expect {  patch :set_best,
                        question_id: user_question,
                        id: user_question_answer,
                        format: :js
                  user_question_answer.reload
        }.to_not change(user_question_answer, :is_best)
      end
    end
  end

  describe 'PATCH #vote_up' do
    before do
      log_in user
    end

    it 'increase vote for smb answer' do
      patch :vote_up, id: answer, question_id: question, format: :json
      answer.reload
      expect(answer.votes.rating).to eq 1
      expect(answer.votes.upvotes.rating).to eq 1
    end

    it 'renders vote.json.jbuilder' do
      patch :vote_up, id: answer, question_id: question, format: :json
      expect(response).to render_template :vote
    end

    it 'not changed vote for own answer' do
      patch :vote_up, id: user_answer, question_id: user_answer.question_id, format: :json
      user_answer.reload
      expect(user_answer.votes.rating).to eq 0
      expect(user_answer.votes.upvotes.rating).to eq 0
    end
  end

  describe 'PATCH #vote_down' do
    before do
      log_in user
    end

    it 'decrease vote for smb answer' do
      patch :vote_down, id: answer, question_id: question, format: :json
      answer.reload
      expect(answer.votes.rating).to eq -1
      expect(answer.votes.downvotes.rating).to eq -1
    end

    it 'renders vote.json.jbuilder' do
      patch :vote_down, id: answer, question_id: question, format: :json
      expect(response).to render_template :vote
    end

    it 'not changed vote for own answer' do
      patch :vote_down, id: user_answer, question_id: user_answer.question_id, format: :json
      user_answer.reload
      expect(user_answer.votes.rating).to eq 0
      expect(user_answer.votes.upvotes.rating).to eq 0
    end
  end

  describe 'PATCH #vote_reset' do
    before do
      log_in user
    end

    it 'reset vote for smb answer' do
      patch :vote_up, id: answer, question_id: question, format: :json
      answer.reload
      patch :vote_reset, id: answer, question_id: question, format: :json
      answer.reload
      expect(answer.votes.rating).to eq 0
      expect(answer.votes.upvotes.rating).to eq 0
    end

    it 'renders vote.json.jbuilder' do
      patch :vote_up, id: answer, question_id: question, format: :json
      answer.reload
      patch :vote_reset, id: answer, question_id: question, format: :json
      expect(response).to render_template :vote
    end
  end
end

