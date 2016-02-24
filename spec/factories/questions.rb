FactoryGirl.define do
  sequence :title do |n|
    "Question title #{n}"
  end

  sequence :body do |n|
    "Question body #{n}"
  end

  factory :question do
    title
    body
    user

    factory :question_with_attachments, class: 'Question' do
      after(:create) do |question|
        question.attachments << create(:question_attachment)
      end
    end
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
    user
  end

  factory :tags_question, class: 'Question' do
    title
    body '#Test question #body #ruby'
    user
  end
end

