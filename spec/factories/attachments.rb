FactoryGirl.define do
  factory :question_attachment, class: 'Attachment' do
    association :attachable, factory: :question
    file { File.open "#{Rails.root}/spec/fixtures/test1.txt" }
  end

  factory :answer_attachment, class: 'Attachment' do
    association :attachable, factory: :answer
    file { File.open "#{Rails.root}/spec/fixtures/test2.txt" }
  end
end

