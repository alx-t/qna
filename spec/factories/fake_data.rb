FactoryGirl.define do
  sequence(:fake_title) { Faker::Hipster.sentence(rand(3..5)).chop! + "?" }
  sequence(:fake_body) { Faker::Hipster.paragraph(5..10) }

  factory :fake_question, class: 'Question' do
    title { FactoryGirl.generate(:fake_title) }
    body { FactoryGirl.generate(:fake_body) }
    user
  end

  factory :fake_answer, class: 'Answer' do
    body { FactoryGirl.generate(:fake_body) }
    question
    user
  end

  factory :fake_comment, class: 'Comment' do
    body { FactoryGirl.generate(:fake_body) }
    user
  end
end

