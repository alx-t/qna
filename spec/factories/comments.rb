FactoryGirl.define do
  factory :question_comment, class: 'Comment' do
    user
    sequence(:body) { |n| "Comment body #{n}" }
    association :commentable, factory: :question
  end

  factory :answer_comment, class: 'Comment' do
    user
    sequence(:body) { |n| "Comment body #{n}" }
    association :commentable, factory: :answer
  end

  factory :invalid_comment, class: 'Comment' do
    user nil
    body nil
  end
end

