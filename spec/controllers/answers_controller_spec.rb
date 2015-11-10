require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }

  describe "GET #new" do
    before { get :new, question_id: question }

    it "assigns a new Answer to @answer" do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it "renders new view" do
      expect(response).to render_template :new
    end
  end

  describe "GET #edit" do
    before { get :edit, id: answer, question_id: question }

    it "assigns the requested answer to @answer" do
      expect(assigns(:answer)).to eq answer
    end

    it "renders edit view" do
      expect(response).to render_template :edit
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves the new answer in th database" do
        expect { post :create,
          question_id: question,
          answer: attributes_for(:answer) }.to change(Answer, :count).by(1)
      end

      it "redirect to question show view" do
        post :create, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context "with invalid attributes" do
      it "does not save the answer" do
        expect { post :create,
          question_id: question,
          answer: attributes_for(:invalid_answer) }.to_not change(Answer, :count)
      end

      it "re-render new view" do
        post :create,
          question_id: question,
          answer: attributes_for(:invalid_answer)
        expect(response).to render_template :new
      end
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "assign the requested answer to @answer" do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer)
        expect(assigns(:answer)).to eq answer
      end

      it "changes answer attributes" do
        patch :update, id: answer, question_id: question, answer: { body: "new body" }
        answer.reload
        expect(answer.body).to eq "new body"
      end

      it "redirects to the question" do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer)
        expect(response).to redirect_to question
      end
    end

    context "with invalid attributes" do
      before { patch :update,
                     id: answer,
                     question_id: question,
                     answer: { body: nil } }

      it "does not change answer attributes" do
        answer.reload
        expect(answer.body).to eq "MyText"
      end

      it "re-render edit view" do
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE #destroy" do
    before { answer }

    it "deletes answer" do
      expect { delete :destroy, id: answer, question_id: question }
        .to change(Answer, :count).by(-1)
    end

    it "redirects to question" do
      delete :destroy, id: answer, question_id: question
      expect(response).to redirect_to question
    end
  end
end

