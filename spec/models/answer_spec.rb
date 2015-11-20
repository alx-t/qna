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

  describe 'set best' do
    it 'setting is_best to true' do
      answers

      expect(answers[0].is_best?).to eq false
      answers[0].set_best
      expect(answers[0].reload.is_best?).to eq true

      answers[2].set_best
      expect(answers[0].reload.is_best?).to eq false
      expect(answers[2].reload.is_best?).to eq true
    end

    it 'ordering - last answer in the bottom, best - in the top' do
      answers
      best_answer

      expect(question.answers.last).to eq best_answer

      best_answer.set_best
      question.reload
      expect(question.answers.first).to eq best_answer
    end
  end
end
