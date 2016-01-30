require_relative 'acceptance_helper'

feature 'Question stories', %q{
  In order to working with questions
  As an authenticated user
  I want to be able working with questions
} do

  given!(:user) { create(:user) }
  given!(:user_question) { create(:question, user: user) }
  given!(:smb_question) { create(:question) }

  scenario 'Authenticated user creates question' do
    sign_in user

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test question body'
    click_on 'Create'
    expect(page).to have_content 'Question was successfully created.'
    expect(page).to have_content 'Test question body'
    expect(page.status_code).to eq 200
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path
    expect(page).to_not have_content 'Ask question'

    visit new_question_path
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Authenticated user deletes his own question' do
    sign_in(user)
    visit question_path user_question
    click_on 'Delete'
    expect(page).to have_content 'Array was successfully destroyed'
  end

  scenario 'Authenticates user tries to delete smb question' do
    sign_in(user)
    visit question_path smb_question
    expect(page).to_not have_content 'Delete'
  end

  scenario 'Non-authenticated user tries to delete question' do
    visit question_path smb_question
    expect(page).to_not have_content 'Delete'
  end

  scenario 'Authenticated user edits his own question' do
    sign_in(user)
    visit question_path user_question
    click_on 'Edit'
    fill_in 'Title', with: 'New title'
    fill_in 'Body', with: 'New body'
    click_on 'Create'
    expect(page).to have_content 'New title'
    expect(page).to have_content 'Question was successfully updated'
    expect(page.status_code).to eq 200
  end

  scenario 'Authenticates user tries to edit smb question' do
    sign_in user
    visit question_path smb_question
    expect(page).to_not have_content 'Edit'
  end

  scenario 'Non-authenticated user tries to edit question' do
    visit question_path smb_question
    expect(page).to_not have_content 'Edit'

    visit edit_question_path smb_question
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'User reviews list of questions' do
    visit questions_path
    expect(page).to have_content user_question.title
    expect(page).to have_content smb_question.title
  end

  scenario 'User reviews the question' do
    visit question_path smb_question
    expect(page).to have_content smb_question.title
    expect(page).to have_content smb_question.body
  end
end

