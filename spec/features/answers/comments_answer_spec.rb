require_relative '../acceptance_helper'

feature 'Commenting answer stories', %q{
  In order to comment answers
  As an authenticated user
  I want to be able comments answers
} do

  given!(:user) { create :user }
  given!(:question) { create :question }
  given!(:question_answer) { create :answer, question: question }

  background do
    sign_in user
    visit question_path question
  end

  scenario 'User comments answer', js: true do
    within '.answer-comments' do
      fill_in 'Comment', with: 'Test comment'
      click_on 'Add comment'

      expect(page).to have_content 'Test comment'
      expect(current_path).to eq question_path(question)
    end
  end

  scenario 'Non-authenticated user tries to comment answer' do
    within '.answer-comments' do
      expect(page).to_not have_content 'Add comment'
    end
  end
end

