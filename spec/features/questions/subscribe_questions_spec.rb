require_relative '../acceptance_helper'

feature 'Subscribe to questions', %q{
  In order to subscribing questions
  As an authenticated user
  I want to be able subscribe questions
} do

  given(:question) { create :question }
  given(:user) { create :user }

  describe 'Authenticated user' do
    scenario 'Can subscribe' do
      sign_in user
      visit question_path question

      click_on 'Subscribe'

      expect(page).to have_link 'Unsubscribe'
      expect(page).to_not have_link 'Subscribe'
    end

    scenario 'Can unsubscribe' do
        sign_in user
        visit question_path question

        click_on 'Subscribe'
        click_on 'Unsubscribe'

        expect(page).to_not have_link 'Unsubscribe'
        expect(page).to have_link 'Subscribe'
    end
  end

  scenario 'Non-authenticated user tries to subscribe' do
    visit question_path question

    expect(page).to_not have_link 'Subscribe'
    expect(page).to_not have_link 'Unsubscribe'
  end
end

