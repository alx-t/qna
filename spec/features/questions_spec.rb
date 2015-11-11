require 'rails_helper'

feature 'Question stories', %q{
  In order to working with questions
  As an authenticated user
  I want to be able working with questions
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test question body'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Authenticated user deletes his own question'
  scenario 'Authenticates user tries to delete smb question'
  scenario 'Non-authenticated user tries to delete question'

  scenario 'Authenticated user edits his own question'
  scenario 'Authenticates user tries to edit smb question'
  scenario 'Non-authenticated user tries to edit question'

  scenario 'User view list of questions'
  scenario 'User view the question'
end
