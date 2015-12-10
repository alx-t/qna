require_relative '../acceptance_helper'

feature 'Commenting question stories', %q{
  In order to comment questions
  As an authenticated user
  I want to be able comments questions
} do

  given(:user) { create :user }
  given(:question) { create :question }

  background do
    sign_in user
    visit question_path question
  end

  scenario 'User comments question', js: true do
    within '.question-comments' do
      click_on 'Add comment'
      fill_in 'Comment', with: 'Test comment'
      click_on 'Create comment'

      expect(page).to have_content 'Test comment'
      expect(current_path).to eq question_path(question)
    end
  end

  scenario 'Non-authenticated user tries to comment question' do
    within '.question-comments' do
      expect(page).to_not have_content 'Add comment'
    end
  end
end

