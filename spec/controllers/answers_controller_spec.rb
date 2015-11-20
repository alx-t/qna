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
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new answer in th database' do
        expect do
          post :create,
               question_id: question,
               answer: attributes_for(:answer),
               format: :js
        end.to change { question.answers.count }.by(1)
      end

      it 'renders create template' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect do
          post :create,
               question_id: question,
               answer: attributes_for(:invalid_answer),
               format: :js
        end.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create,
             question_id: question,
             answer: attributes_for(:invalid_answer),
             format: :js
        expect(response).to render_template :create
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

      it 'render update template' do
        patch :update, id: user_answer,
                       question_id: question,
                       format: :js,
                       answer: { body: 'new body' }
        expect(response).to render_template :update
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

      it 'render template update' do
        expect(response).to render_template :update
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
end

