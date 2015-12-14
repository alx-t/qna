require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'validations tests' do
    it { should validate_presence_of :body }
    it { should validate_presence_of :user_id }
    #it do
    #  create :question_comment
    #  should validate_uniqueness_of(:user_id).scoped_to(:commentable_type, :commentable_id)
    #end
  end

  describe 'associations tests' do
    it { belong_to :user }
    it { belong_to :commentable }
  end
end

