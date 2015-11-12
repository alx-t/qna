FactoryGirl.define do
  factory :answer do
    question nil
    body 'MyText'
    user
  end

  factory :invalid_answer, class: 'Answer' do
    question nil
    body nil
    user
  end
end
