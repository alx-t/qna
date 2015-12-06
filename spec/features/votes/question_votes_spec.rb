require_relative '../acceptance_helper'

feature 'Voting the question', %q{
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

    scenario 'Voting for smb question', js: true do
      visit question_path smb_question

      within '.question-votes' do
        expect(page).to_not have_link 'Reset'
        expect(page).to have_link 'Up'
        expect(page).to have_link 'Down'

        click_on 'Up'
        expect(page).to have_link 'Reset'
        expect(page).to_not have_link 'Up'
        expect(page).to_not have_link 'Down'
        expect(page).to have_content 'Upvotes: 1'
        expect(page).to have_content 'Rating: 1'
      end
    end

    scenario 'Trying to vote for own question' do
      visit question_path user_question

      within '.question-votes' do
        expect(page).to_not have_link 'Reset'
        expect(page).to_not have_link 'Up'
        expect(page).to_not have_link 'Down'
      end
    end

    scenario 'Canceling previous vote and revote', js: true do
      visit question_path smb_question
      click_on 'Down'
      click_on 'Reset'
      click_on 'Up'

      within '.question-votes' do
        expect(page).to have_link 'Reset'
        expect(page).to_not have_link 'Up'
        expect(page).to_not have_link 'Down'
        expect(page).to have_content 'Upvotes: 1'
        expect(page).to have_content 'Rating: 1'
      end
    end
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

