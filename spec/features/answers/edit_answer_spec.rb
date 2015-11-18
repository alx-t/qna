require_relative '../acceptance_helper'

feature 'Edit answer', %q{
  In order to fix mistake
  As an author of answer
  I'd like to be edit my answer
} do

  given(:user) { create :user }
  given!(:question) { create :question }
  given(:answer) { create :answer, question: question }
  given(:user_answer) { create :answer, question: question, user: user }

  describe 'Authenticated user' do
    before do
      sign_in user
      #visit question_path question
    end

    scenario 'tries to edit his own answer' do
      user_answer
      visit question_path question

      within('.answers') do
        expect(page).to have_link 'Edit'
        click_on 'Edit'

        fill_in 'Body', with: 'New answer body'
        click_on 'Save'

        expect(page).to_not have_content user_answer.body
        expect(page).to have_content 'New answer body'
        expect(page).to_not have_selector rextarea
      end
    end

    scenario 'tries to edit smb answer'
  end

  scenario 'Non-authenticated user tries to edit answer' do
    answer

    visit question_path question
    expect(page).to_not have_content 'Edit'

    visit edit_question_answer_path question, answer
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end

