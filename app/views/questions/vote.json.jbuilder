json.extract! @votable, :id
json.upvotes @votable.votes.upvotes.rating
json.downvotes @votable.votes.downvotes.rating
json.rating @votable.votes.rating
json.voted @votable.voted_for? current_user
json.vote_up_url vote_up_question_path(@votable)
json.vote_down_url vote_down_question_path(@votable)
json.vote_reset_url vote_reset_question_path(@votable)

