require_relative '../acceptance_helper'

feature 'Best answer', %q{
  In order to set the best answer
  As an author of the question
  I'd like to set the best answer
} do

  given(:user) { create :user }
  given(:question) { create :question }
  given(:user_question) { create :question, user: user }
  given(:answer) { create :answer, question: question }
  given(:answer_user_question) { create :answer, question: user_question }

  describe 'Authenticated user' do
    before { sign_in user }

    scenario 'as a question author set the best answer', js: true do
      user_question
      answer_user_question

      visit question_path user_question
      expect(page).to have_link 'Best answer'

      click_on 'Best answer'
      expect(page).to have_content 'The best answer'
    end

    scenario 'not a question author tries to set best answer' do
      question
      answer

      visit question_path question
      expect(page).to_not have_link 'Best answer'
    end
  end

  scenario 'Non-authenticated user tries to set the best answer' do
    answer

    visit question_path question
    expect(page).to_not have_link 'Best answer'
  end
end

