require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create :user }
  let(:question) {  create :question }
  let(:answer) { create :answer, question: question }

  describe 'POST #create' do
    context 'questions' do
      context 'with valid attributes' do
        sign_in_user

        it 'create question comment' do
          expect { post :create, question_id: question.id, commentable: 'questions', comment: attributes_for(:question_comment), format: :json }
            .to change(Comment, :count).by(1)
          should respond_with(200)
        end

        it 'renders show template' do
          post :create, question_id: question.id, commentable: 'questions', comment: attributes_for(:question_comment), format: :json
          expect(response).to render_template 'comments/show'
        end
      end

      context 'with invalid attributes' do
        sign_in_user

        it 'tries to create question comment' do
          expect { post :create, question_id: question.id, commentable: 'questions', comment: attributes_for(:invalid_comment), format: :json }
            .to_not change(Comment, :count)
          should respond_with(422)
        end
      end

      context 'non-authenticated user' do
        it 'tries to create question comment' do
          expect { post :create, question_id: question.id, commentable: 'questions', comment: attributes_for(:question_comment), format: :json }
            .to_not change(Comment, :count)
          should respond_with(401)
        end
      end
    end

    context 'answers' do
      context 'with valid attributes' do
        sign_in_user

        it 'create answer comment' do
          expect { post :create, question_id: question.id, answer_id: answer.id, commentable: 'answers', comment: attributes_for(:answer_comment), format: :json }
            .to change(Comment, :count).by(1)
          should respond_with(200)
        end

        it 'renders show template' do
          post :create, question_id: question.id, answer_id: answer.id, commentable: 'answers', comment: attributes_for(:answer_comment), format: :json
          expect(response).to render_template 'comments/show'
        end
      end

      context 'with invalid attributes' do
        sign_in_user

        it 'tries to create question comment' do
          expect { post :create, question_id: question.id, answer_id: answer.id, commentable: 'answers', comment: attributes_for(:invalid_comment), format: :json }
            .to change(Comment, :count).by(0)
          should respond_with(422)
        end
      end

      context 'non-authenticated user' do
        it 'tries to create answer comment' do
          expect { post :create, question_id: question.id, answer_id: answer.id, commentable: 'answers', comment: attributes_for(:answer_comment), format: :json }
            .to_not change(Comment, :count)
          should respond_with(401)
        end
      end
    end
  end
end

