require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create :question }
  let(:user) { create :user }
  let(:user_question) { create :question, user: user }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before do
      get :index
    end

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before do
      get :show, id: question
    end

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user

      get :edit, id: user_question
    end

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq user_question
    end

    it 'renders edit vew' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it 'redirect to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, question: attributes_for(:invalid_question) }
          .to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user
    end

    context 'with valid attributes' do
      it 'changes question attributes' do
        patch :update, id: user_question,
                       question: { title: 'test title', body: 'test body' }
        user_question.reload
        expect(user_question.title).to eq 'test title'
        expect(user_question.body).to eq 'test body'
      end

      it 'redirects to the updated question' do
        patch :update, id: user_question,
                       question: { title: 'test title', body: 'test body' }
        expect(response).to redirect_to user_question
      end
    end

    context 'with invalid attributes' do
      before do
        @old_question = user_question.dup
        patch :update, id: user_question,
                       question: { title: 'test title', body: nil }
      end

      it 'does not change question attributes' do
        user_question.reload
        expect(user_question.title).to eq @old_question.title
        expect(user_question.body).to eq @old_question.body
      end

      it 're-render edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user
      user_question
    end

    it 'deletes question' do
      expect { delete :destroy, id: user_question }.to change(Question, :count).by(-1)
    end

    it 'redirect to index view' do
      delete :destroy, id: user_question
      expect(response).to redirect_to questions_path
    end
  end
end

