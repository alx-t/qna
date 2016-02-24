require_relative '../acceptance_helper'
require_relative '../sphinx_helper'

feature 'Search', %q{
  In order to search information
  As an user
  I want to be able to search with sphinx
} do

  given!(:matched_title_question) { create :question, title: 'matched title question' }
  given!(:matched_body_question) { create :question, body: 'matched body question' }
  given!(:matched_tags_question) { create :question, body: 'hashtags #body question #test' }
  given!(:matched_answer) { create :answer, body: 'matched body answer' }
  given!(:matched_comment) { create :question_comment, body: 'matched body comment' }
  given!(:matched_user) { create :user, email: 'user@matched.com' }

  before do
    index
    visit root_path
  end

  scenario 'Search in questions', js: true do
    fill_in 'query_query', with: 'matched'
    select('Questions', from: 'query_condition')
    click_on 'Search'

    within '.search_results' do
      expect(page).to have_content 'matched title question'
      expect(page).to have_content matched_body_question.title
      expect(page).to have_selector('div', count: 2)
    end
  end

  scenario 'Search in answers', js: true do
    fill_in 'query_query', with: 'matched'
    select('Answers', from: 'query_condition')
    click_on 'Search'

    within '.search_results' do
      expect(page).to have_content matched_answer.body
      expect(page).to have_selector('div', count: 1)
    end
  end

  scenario 'Search in comments', js: true do
    fill_in 'query_query', with: 'matched'
    select('Comments', from: 'query_condition')
    click_on 'Search'

    within '.search_results' do
      expect(page).to have_content matched_comment.body
      expect(page).to have_selector('div', count: 1)
    end
  end

  scenario 'Search in users', js: true do
    fill_in 'query_query', with: 'matched'
    select('Users', from: 'query_condition')
    click_on 'Search'

    within '.search_results' do
      expect(page).to have_content matched_user.email
      expect(page).to have_selector('div', count: 1)
    end
  end

  scenario 'Search in tags', js: true do
    fill_in 'query_query', with: '#test'
    select('Tags', from: 'query_condition')
    click_on 'Search'

    within '.search_results' do
      expect(page).to have_content matched_tags_question.title
      expect(page).to have_selector('div', count: 1)
    end
  end

  scenario 'Search everywhere', js: true do
    fill_in 'query_query', with: 'matched'
    select('Everywhere', from: 'query_condition')
    click_on 'Search'

    within '.search_results' do
      expect(page).to have_selector('div', count: 5)
    end
  end
end

