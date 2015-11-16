require 'rails_helper'


feature 'Answer stories', %q{
  In order to working with answers
  As an authenticated user
  I want to be able working with answers
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }
  given(:user_answer) { create(:answer, question: question, user: user) }

  scenario 'User reviews answers' do
    answer

    visit question_path question
    expect(page).to have_content answer.body
  end

  scenario 'Authenticated user creates answer', js: true do
    sign_in user
    visit question_path question
    fill_in 'Body', with: 'Test answer body'
    click_on 'Add answer'
    expect(page).to have_content 'Test answer body'
  end

  scenario 'Non-authenticated user tries to create answer' do
    visit question_path question
    expect(page).to_not have_content 'Add answer'

    visit new_question_answer_path question
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Authenticated user edits his own answer' do
    user_answer

    sign_in user
    visit question_path question
    find('.answers').click_on('Edit')

    fill_in 'Body', with: 'New answer body'
    click_on 'Add answer'
    expect(page).to have_content 'New answer body'
    expect(page).to have_content 'Your answer successfully changed'
  end

  scenario 'Authenticated user tries to edit smb answer' do
    answer

    sign_in user
    visit question_path question
    within('.answers') { expect(page).to_not have_content 'Edit' }

    visit edit_question_answer_path question, answer
    expect(page).to have_content 'You can not edit this answer'
  end

  scenario 'Non-authenticated user tries to edit answer' do
    answer

    visit question_path question
    expect(page).to_not have_content 'Edit'

    visit edit_question_answer_path question, answer
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Authenticated user deletes his own answer', js: true do
    user_answer

    sign_in(user)
    visit question_path question
    find('.answers').click_on 'Delete'
    expect(page).to have_content 'Your answer successfully deleted'
  end

  scenario 'Authenticated user tries to delete smb answer' do
    answer

    sign_in(user)
    visit question_path question
    within('.answers') { expect(page).to_not have_content 'Delete' }
  end

  scenario 'Non-authenticated user tries to delete answer' do
    answer

    visit question_path question
    expect(page).to_not have_content 'Delete'
  end
end

