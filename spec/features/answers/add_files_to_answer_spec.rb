require_relative '../acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate answer
  As an answer's author
  I'd like to be able to attach files
} do

  given(:user) { create :user }
  given(:question) { create :question }
  given(:answer_with_attachments) { create :answer_with_attachments,
                                           question: question,
                                           user: user }

  context 'Create new answer' do
    background do
      sign_in user
      visit question_path question
    end

    scenario 'User adds files when create answer', js: true do
      add_attachment
      click_on 'Add answer'

      within '.answers' do
        expect(page).to have_link 'test1.txt', href: "/uploads/attachment/file/1/test1.txt"
      end
    end

    scenario 'add some files to answer', js: true do
      add_attachment

      click_on 'Add file'
      all('input[type="file"]')[1].set "#{Rails.root}/spec/fixtures/test2.txt"
      click_on 'Add answer'

      within '.answers' do
        expect(page).to have_link 'test1.txt'
        expect(page).to have_link 'test2.txt'
      end
    end
  end

  context 'Edit answer' do
    background do
      answer_with_attachments
      sign_in user
      visit question_path question
    end

    scenario 'remove files on edit answer', js:true do
      within '.answers' do
        click_on 'Edit'
        click_on 'Remove file'
        click_on 'Save'
      end

      expect(page).to have_content 'Your answer successfully changed'
      expect(page).to_not have_link 'test1.txt'
    end

    scenario 'add files on edit answer', js: true do
      find('.answers').click_on 'Edit'

      find('.answer-edit').click_on 'Add file'
      all('input[type="file"]')[1].set "#{Rails.root}/spec/fixtures/test2.txt"
      click_on 'Save'

      expect(page).to have_content 'Your answer successfully changed'
      expect(page).to have_link 'test2.txt'
    end
  end

  def add_attachment
    fill_in 'Body', with: 'Test answer body'
    attach_file 'File', "#{Rails.root}/spec/fixtures/test1.txt"
  end
end

