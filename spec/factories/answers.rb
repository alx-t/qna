FactoryGirl.define do
  factory :answer do
    question nil
    sequence(:body) { |n| "Answer body #{n}" }
    user
  end

  factory :invalid_answer, class: 'Answer' do
    question nil
    body nil
    user
  end
end
