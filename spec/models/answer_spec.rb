require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:question) { create :question }
  let(:answers) { create_list :answer, 3, question: question }
  let(:best_answer) { create :answer, question: question, body: 'the best' }

  describe 'validations tests' do
    it { should validate_presence_of :body }
    it { should validate_presence_of :question_id }
    it { should validate_presence_of :user_id }
  end

  describe 'associations tests' do
    it { should belong_to :question }
    it { should belong_to :user }
  end

  describe 'ordering' do
    it 'last answer in the bottom, best - in the top' do
      answers
      best_answer

      expect(question.answers.last).to eq best_answer

      best_answer.set_best
      question.reload
      expect(question.answers.first).to eq best_answer
    end
  end
end
