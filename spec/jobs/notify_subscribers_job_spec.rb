require 'rails_helper'

RSpec.describe NotifySubscribersJob, type: :job do
  let!(:users) { create_list :user, 2 }
  let!(:question) { create :question }

  it "sends notifications for question's subscribers" do
    question.subscribers.each do |user|
      expect(SubscribersMailer).to receive(:new_answer_notification).
        with(user, question).
        and_call_original
    end
    NotifySubscribersJob.perform_now(question)
  end
end

