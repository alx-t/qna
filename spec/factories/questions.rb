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
  end

  factory :invalid_question, class: 'Question' do
    title nil
    body nil
    user
  end
end

