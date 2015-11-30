FactoryGirl.define do
  factory :question_vote, class: 'Vote' do
    user
    value 1
    association :votable, factory: :question
  end
end
