require_relative '../acceptance_helper'

feature 'Best answer', %q{
  In order to set the best answer
  As an author of the question
  I'd like to set the best answer
} do

  given(:user) { create :user }

  given(:question) { create :question }
  given(:answer) { create :answer, question: question }

  given(:user_question) { create :question, user: user }
  given(:answer_user_question) { create :answer, question: user_question }
  given(:another_answer_user_question) { create :answer, question: user_question }

  describe 'Authenticated user' do
    before { sign_in user }

    scenario 'as a question author set the best answer', js: true do
      user_question
      answer_user_question

      visit question_path user_question
      expect(page).to have_link 'Best answer'

      click_on 'Best answer'
      expect(page).to have_content 'Your best answer successfully selected'
      expect(page).to have_content 'The best answer'
      expect(page).to_not have_link 'Best answer'
    end

    scenario 'not a question author tries to set best answer' do
      question
      answer

      visit question_path question
      expect(page).to_not have_link 'Best answer'
    end

    scenario 'best answer is the first in list', js: true do
      user_question
      answer_user_question
      another_answer_user_question

      visit question_path user_question

      click_on "set-best-link-#{answer_user_question.id}"
      within('.answers .answer:first-child p') do
        expect(page).to have_content answer_user_question.body
      end

      click_on "set-best-link-#{another_answer_user_question.id}"
      within('.answers .answer:first-child p') do
        expect(page).to have_content another_answer_user_question.body
      end
    end

    scenario 'change best answer', js: true do
      user_question
      answer_user_question
      another_answer_user_question

      visit question_path user_question

      within "div#answer-id-#{answer_user_question.id}" do
        click_on 'Best answer'
        expect(page).to have_content 'The best answer'
        expect(page).to_not have_link 'Best answer'
      end
      expect(page).to have_content('The best answer', count: 1)

      within "div#answer-id-#{another_answer_user_question.id}" do
        click_on 'Best answer'
        expect(page).to have_content 'The best answer'
        expect(page).to_not have_link 'Best answer'
      end

      within "div#answer-id-#{answer_user_question.id}" do
        expect(page).to_not have_content 'The best answer'
      end
    end
  end

  scenario 'Non-authenticated user tries to set the best answer' do
    answer

    visit question_path question
    expect(page).to_not have_link 'Best answer'
  end
end

