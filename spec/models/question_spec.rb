require 'rails_helper'

RSpec.describe Question, type: :model do

  subject { build :question }

  describe 'validations tests' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
    it { should validate_presence_of :user_id }
  end

  describe 'associations tests' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should belong_to(:user) }
    it { should have_many(:attachments).dependent(:destroy) }
    it { should have_many(:votes).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
    it { should have_many(:subscribers).through(:subscriptions).class_name('User') }

    it { should accept_nested_attributes_for :attachments }
  end

  context 'can subscribe user' do
    let(:user) { create :user }
    let(:question) { create :question }

    it 'subscribes new user' do
      expect { question.subscribe(user) }.to change(question.subscribers, :count).by(1)
    end

    it 'tries to subscribe already subscribed user' do
      question.subscribe user
      expect { question.subscribe(user) }.to_not change(question.subscribers, :count)
    end
  end

  context 'can unsubscribe user' do
    let(:user) { create :user }
    let(:question) { create :question }

    it 'unsubscribe subscribed user' do
      question.subscribe user
      expect { question.unsubscribe(user) }.to change(question.subscribers, :count).by(-1)
    end

    it 'tries to unsubscribe not subscribed user' do
      expect { question.unsubscribe(user) }.to_not change(question.subscribers, :count)
    end
  end

  it 'subscribe author after creating question' do
    expect(subject).to receive(:subscribe).with(subject.user)
    subject.save!
  end

  context 'can store tags array' do
    let!(:tags_question) { create :tags_question }

    it 'store tags' do
      expect(tags_question.hashtags).to match_array(%w(#test #body #ruby))
    end

    it 'update tags' do
      tags_question.update body: "test #rails"
      expect(tags_question.hashtags).to match_array(%w(#rails))
    end
  end
end

