shared_examples_for "Model votable" do |object|
  describe "#{object} voting" do
    let(:user) { create :user }
    let!(:votable) { create object.to_s.underscore.to_sym }

    it "#{object} vote up" do
      votable.vote_up(user)
      expect(votable.votes.upvotes.rating).to eq 1
      expect(votable.votes.rating).to eq 1
    end

    it "#{object} vote down" do
      votable.vote_down(user)
      expect(votable.votes.downvotes.rating).to eq -1
      expect(votable.votes.rating).to eq -1
    end

    it "#{object} vote reset" do
      votable.vote_up(user)
      votable.vote_reset(user)
      expect(votable.votes.upvotes.rating).to eq 0
      expect(votable.votes.rating).to eq 0
    end

    it "same user same #{object} double vote up" do
      votable.vote_up(user)
      votable.vote_up(user)
      expect(votable.votes.upvotes.rating).to eq 1
      expect(votable.votes.rating).to eq 1
    end
  end
end

