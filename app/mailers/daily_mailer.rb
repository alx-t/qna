class DailyMailer < ApplicationMailer
  def digest(user)
    @greeting = "Hi #{user.email}"
    @questions = Question.yesterdays

    mail to: user.email, subject: "#{Time.now.strftime('%d/%m/%Y')} QnA daily digest"
  end
end
