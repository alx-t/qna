require 'rails_helper'

RSpec.describe Question, type: :model do

  describe "validation tests" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  describe "association tests" do
    it { should have_many(:answers).dependent(:destroy) }
  end
end

