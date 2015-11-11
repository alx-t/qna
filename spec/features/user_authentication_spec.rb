require 'rails_helper'

feature 'User sign in', %q{
  In order to be able to ask question
  As an user
  I want to be able to sign in
} do

  given(:user) { create(:user) }

  scenario 'Registered user try to sign in' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-registered user try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_button 'Log in'

    expect(page).to have_content 'Invalid email or password'
    expect(current_path).to eq new_user_session_path
  end

  scenario 'Authenticated user try logout' do
    sign_in(user)

    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'User try to register' do
    visit root_path
    click_on 'Register'

    fill_in 'Email', with: 'test_user@test.com'
    fill_in 'Password', with: '12345678', match: :prefer_exact
    fill_in 'user_password_confirmation', with: '12345678'

    click_on 'Sign up'

    expect(page).to have_content 'You have signed up successfully.'
  end
end

