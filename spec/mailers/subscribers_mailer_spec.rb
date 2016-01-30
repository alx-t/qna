require "rails_helper"

RSpec.describe SubscribersMailer, type: :mailer do
  describe 'new_answer_notification' do
    let!(:user) { create :user }
    let!(:question) { create :question }
    let!(:mail) { SubscribersMailer.new_answer_notification user, question }

    it 'renders headers' do
      expect(mail.subject).to eq('New answer notification')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq([Rails.application.secrets.email_user_from])
    end

    it 'renders body' do
      expect(mail.body.encoded).to match("Hi #{user.email}")
      expect(mail.body.encoded).to match(question.title)
    end
  end
end

