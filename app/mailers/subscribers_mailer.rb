class SubscribersMailer < ApplicationMailer
  def new_answer_notification(user, question)
    @greeting = "Hi #{user.email}"
    @question = question

    mail to: user.email, subject: 'New answer notification'
  end
end

