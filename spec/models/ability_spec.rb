require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guests' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other_user) { create :user }

    let(:question) { create :question, user: user }
    let(:other_question) { create :question, user: other_user }

    let(:answer) { create :answer, question: question, user: user }
    let(:other_answer) { create :answer, question: other_question, user: other_user }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :manage, question, user: user }
    it { should_not be_able_to :manage, other_question, user: user }

    it { should be_able_to :manage, answer, user: user }
    it { should_not be_able_to :manage, other_answer, user: user }

    it { should be_able_to :create, Comment }

    it { should be_able_to :manage, create(:question_attachment, attachable: question), user: user }
    it { should_not be_able_to :manage, create(:question_attachment) }

    it { should be_able_to :vote, other_question, user: user }
    it { should_not be_able_to :vote, question, user: user }
    it { should be_able_to :vote, other_answer, user: user }
    it { should_not be_able_to :vote, answer, user: user }

    it { should be_able_to :set_best, answer, user: user }
    it { should_not be_able_to :set_best, other_answer, user: user }

    it { should be_able_to :subscribe, create(:question), user: user }

    let!(:subscribed_question) { create :question }

    it 'can not subscribe if already subscribed' do
      subscribed_question.subscribe user
      should_not be_able_to :subscribe, subscribed_question, user: user
    end

    it { should_not be_able_to :unsubscribe, create(:question), user: user }

    it 'can unsubscribe if already subscribed' do
      subscribed_question.subscribe user
      should be_able_to :unsubscribe, subscribed_question, user: user
    end
  end
end

