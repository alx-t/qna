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

  it_behaves_like "Model votable", Question
  it_behaves_like "Model votable", Answer
end

