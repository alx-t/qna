FactoryGirl.define do
  factory :question_comment, class: 'Comment' do
    user
    sequence(:body) { |n| "Comment body #{n}" }
    association :commentable, factory: :question
  end
end

