require_relative '../acceptance_helper'

feature 'Sign in via facebook', %q{
  In order to be able to ask question
  As a facebook user
  I want to be able sign in via facebook
} do

  background do
    OmniAuth.config.test_mode = true
    visit root_path
  end

  scenario 'user can sign in via facebook' do
    mock_auth_hash :facebook
    click_on 'Log in'
    expect(page).to have_content 'Sign in with Facebook'

    click_on 'Sign in with Facebook'
    expect(page).to have_content 'Successfully authenticated from Facebook account.'
  end

  scenario 'with invalid credentials' do
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
    click_on 'Log in'
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Could not authenticate you from Facebook because "Invalid credentials"'
  end
end
