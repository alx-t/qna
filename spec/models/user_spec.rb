require 'rails_helper'

RSpec.describe User do
  describe 'validations tests' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  describe 'associations tests' do
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:answers).dependent(:destroy) }
  end
end

