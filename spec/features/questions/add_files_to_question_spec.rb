require_relative '../acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As a question's author
  I'd like to be able to attach files
} do

  given(:user) { create :user }
  given(:question_with_attachments) { create :question_with_attachments, user: user }

  context 'Create new question' do
    background do
      sign_in user
      visit new_question_path
    end

    scenario 'User add file when ask question' do
      add_attachment
      click_on 'Create'

      expect(page).to have_link 'test1.txt', href: "/uploads/attachment/file/1/test1.txt"
    end

    scenario 'add some files to question', js: true do
      add_attachment

      click_on 'Add file'
      all('input[type="file"]')[1].set "#{Rails.root}/spec/fixtures/test2.txt"
      click_on 'Create'

      expect(page).to have_link 'test1.txt'
      expect(page).to have_link 'test2.txt'
    end
  end

  context 'Edit question' do
    background do
      sign_in user
      visit edit_question_path question_with_attachments
    end

    scenario 'remove files on edit question', js: true do
      click_on 'Remove file'
      click_on 'Create'

      expect(page).to have_content 'Your question successfully changed'
      expect(page).to_not have_link 'test1.txt'
    end

    scenario 'add files on edit question', js: true do
      add_attachment
      click_on 'Create'

      expect(page).to have_link 'test1.txt', href: "/uploads/attachment/file/1/test1.txt"
    end
  end

  def add_attachment
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'Test question body'
    attach_file 'File', "#{Rails.root}/spec/fixtures/test1.txt"
  end
end

