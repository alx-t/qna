FactoryGirl.define do
  factory :answer do
    question
    sequence(:body) { |n| "Answer body #{n}" }
    user

    factory :answer_with_attachments, class: 'Answer' do
      after(:create) do |answer|
        answer.attachments << create(:answer_attachment)
      end
    end
  end

  factory :invalid_answer, class: 'Answer' do
    question nil
    body nil
    user
  end
end
