ActiveRecord::Base.transaction do

  20.times { FactoryGirl.create :user, created_at: rand(15).days.ago }

  User.all.each do |user|
    question = FactoryGirl.create :fake_question, user: user, created_at: rand((Date.today - user.created_at.to_date).to_i)
    2.times do
      FactoryGirl.create :fake_comment, commentable: question
      answer = FactoryGirl.create :fake_answer, question: question, created_at: rand((Date.today - question.created_at.to_date).to_i)
      2.times do
        FactoryGirl.create :fake_comment, commentable: answer
      end
    end
  end

end

