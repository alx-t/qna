require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'validations tests' do
    it { should validate_presence_of :value }
    it { should validate_presence_of :user_id }
    it do
      create :question_vote
      should validate_uniqueness_of(:user_id).scoped_to(:votable_type, :votable_id)
    end
  end

  describe 'associations tests' do
    it { belong_to :user }
    it { belong_to :votable }
  end

  describe 'question voting' do
    let(:question) { create :question }
    let(:user) { create :user }

    it 'vote up' do
      question.vote_up(user)
      expect(question.votes.upvotes).to eq 1
      expect(question.votes.rating).to eq 1
    end

    it 'vote down' do
      question.vote_down(user)
      expect(question.votes.downvotes).to eq -1
      expect(question.votes.rating).to eq -1
    end

    it 'vote reset' do
      question.vote_up(user)
      question.vote_reset(user)
      expect(question.votes.upvotes).to eq 0
      expect(question.votes.rating).to eq 0
    end

    it 'same user same question double vote up' do
      question.vote_up(user)
      question.vote_up(user)
      expect(question.votes.upvotes).to eq 1
      expect(question.votes.rating).to eq 1
    end
  end

  describe 'answers voting' do
    let(:answer) { create :answer }
    let(:user) { create :user }

    it 'vote up' do
      answer.vote_up(user)
      expect(answer.votes.upvotes).to eq 1
      expect(answer.votes.rating).to eq 1
    end

    it 'vote down' do
      answer.vote_down(user)
      expect(answer.votes.downvotes).to eq -1
      expect(answer.votes.rating).to eq -1
    end

    it 'vote reset' do
      answer.vote_up(user)
      answer.vote_reset(user)
      expect(answer.votes.upvotes).to eq 0
      expect(answer.votes.rating).to eq 0
    end

    it 'same user same answer double vote up' do
      answer.vote_up(user)
      answer.vote_up(user)
      expect(answer.votes.upvotes).to eq 1
      expect(answer.votes.rating).to eq 1
    end
  end


end

