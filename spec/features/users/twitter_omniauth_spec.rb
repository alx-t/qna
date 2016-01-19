require_relative '../acceptance_helper'

feature 'Sign in via twitter', %q{
  In order to be able to ask question
  As a twitter user
  I want to be able sign in via twitter
} do

  background do
    OmniAuth.config.test_mode = true
    visit root_path
  end

  scenario 'user can sign in via twitter' do
    mock_auth_hash :twitter
    click_on 'Log in'
    expect(page).to have_content 'Sign in with Twitter'

    click_on 'Sign in with Twitter'
    fill_in 'auth_info_email', with: 'new@user.com'
    click_on 'Submit'

    expect(page).to have_content 'Successfully authenticated from Twitter account.'
  end

  scenario 'with invalid credentials' do
    OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
    click_on 'Log in'
    click_on 'Sign in with Twitter'

    expect(page).to have_content 'Could not authenticate you from Twitter because "Invalid credentials"'
  end
end

