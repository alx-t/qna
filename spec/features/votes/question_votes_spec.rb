require_relative '../acceptance_helper'

feature 'Voting the quiestion', %q{
  In order to vote the question
  As an authorized user
  I want to be able vote the question
} do

  given(:user) { create :user }
  given(:user_question) { create :question, user: user }
  given(:smb_question) { create :question }

  context 'Authorized user' do
    background do
      sign_in user
    end

    scenario 'Voting for smb question'

    scenario 'Trying to vote for own question' do
      user_question
      visit question_path user_question

      within '.question-votes' do
        expect(page).to_not have_link 'Reset'
        expect(page).to_not have_link 'Up'
        expect(page).to_not have_link 'Down'
      end
    end

    scenario 'Trying to vote second time'
    scenario 'Canceling previous vote and revote'
    scenario 'Question got total vote'  ##
  end

  context 'Non authorized user' do
    scenario 'trying to vote question' do
      visit question_path smb_question
      within '.question-votes' do
        expect(page).to_not have_link 'Reset'
        expect(page).to_not have_link 'Up'
        expect(page).to_not have_link 'Down'
      end
    end
  end

end
