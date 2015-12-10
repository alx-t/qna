require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create :user }
  let(:question) {  create :question }
  let(:answer) { create :answer }

  describe 'POST #create' do
    context 'questions' do
      context 'with valid attributes'
      context 'with invalid attributes'
    end

    context 'answers' do
      context 'with valid attributes'
      context 'with invalid attributes'
    end
  end
end

