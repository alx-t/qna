json.(@question, :id, votes.upvotes, votes.downvotes, votes.rating)
json.id @question.id
json.votes.upvotes @question.votes.upvotes

