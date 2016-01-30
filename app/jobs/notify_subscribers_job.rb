class NotifySubscribersJob < ActiveJob::Base
  queue_as :default

  def perform(question)
    question.subscribers.each do |user|
      SubscribersMailer.new_answer_notification user, question
    end
  end
end

